import os
import re
import openai
import logging
import time
from tqdm import tqdm
import glob

# ログの設定
logging.basicConfig(filename='translation.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# APIキーを含むファイルのパスを指定
api_key_file = '../../../OpenAI_api_key.txt'

# APIキーを読み込む
with open(api_key_file, 'r') as file:
    openai.api_key = file.read().strip()
    
# 読み込みフォルダと保存フォルダを指定
input_folder = '../jp'
output_folder = '../en'
target_files = []

translation_md_folder = '../translations'  # 翻訳Markdownファイルの出力先フォルダを指定
# 出力先フォルダが存在しない場合は作成
if not os.path.exists(translation_md_folder):
    os.makedirs(translation_md_folder)

# chapter01.qmdからchapter20.qmdまでを確認
for i in range(1, 21):
    file_name = f"chapter{i:02}.qmd"  # ファイル名を生成（例: chapter01.qmd）
    jp_file_path = os.path.join(input_folder, file_name)
    en_file_path = os.path.join(output_folder, file_name)

    # jpフォルダにファイルが存在し、enフォルダには存在しない場合
    if os.path.exists(jp_file_path) and not os.path.exists(en_file_path):
        target_files.append(jp_file_path)

print("Target files:")
for file in target_files:
    print(file)

def Trans_gpt(prompt):
    retry_counter = 0
    while retry_counter < 10:
        try:
            messages = [
                {"role": "system", "content": "You are a translator."},
                {"role": "user", "content": "Never modify the TeX code, translate this Japanese text into English please:"},
                {"role": "assistant", "content": prompt}
            ]
            res = openai.ChatCompletion.create(
                model='gpt-4',
                messages = messages
            )
            time.sleep(1) 
            retry_counter = 0  # リトライカウンターをリセットします
            return res.choices[0]['message']['content']+'\n'
        except openai.error.RateLimitError:
            print(f"Rate limit exceeded. Retrying in {5 ** retry_counter} seconds.")
            time.sleep(2 ** retry_counter)  # Exponential backoff
            retry_counter += 1
        except openai.error.Timeout:
            print(f"Timeout Error. Retrying in {5 * retry_counter} minutes.")
            time.sleep(300 * retry_counter + 10)
            retry_counter += 1
    raise Exception("Failed to get a response from the API after multiple attempts.")

start_time = time.time()


for filename in target_files:
    logging.info(f"Processing {filename}...")
    with open(filename, "r", encoding="utf-8") as file:
        lines = file.readlines()

    base_filename = os.path.basename(filename)
    base_filename_without_ext = os.path.splitext(base_filename)[0]
    new_base_filename = base_filename_without_ext + '.qmd'
    new_filename = os.path.join(output_folder, new_base_filename)
    translation_md_filename = os.path.join(translation_md_folder, base_filename_without_ext + '_trans.md')  # 出力先フォルダを変更
    
    with open(new_filename, 'w', encoding='utf-8') as new_file, open(translation_md_filename, 'w', encoding='utf-8') as md_file:
        # Markdownファイルのヘッダーに表のヘッダーを追加
        md_file.write('| 原文 | 翻訳 |\n')
        md_file.write('|---|---|\n')
        
        for line in tqdm(lines, desc=f'Processing {filename}'):
            if line.startswith("%"):
                new_file.write(line)
                logging.info(f"Comment: {line}")
            else:
                if line.strip():
                    transed = Trans_gpt(line)
                    new_file.write(transed)
                    logging.info(f"Trans Line: {line}")
                    logging.info(f"Transed Line: {transed}")
                    # Markdownファイルに原文と翻訳を表形式で書き出す
                    md_file.write(f"| `{line.strip()}` | `{transed.strip()}` |\n")
                else:
                    new_file.write('\n')




elapsed_time = time.time() - start_time
print("翻訳完了しました。")
logging.info(f"The function took {elapsed_time:.2f} seconds to complete.")
