- root 文字入力 → 英訳
- root→ 履歴表示
  の単純なアプリを作る

設定（APIキー）
- Rails Credentials に保存（推奨）:
  - `bin/rails credentials:edit` を実行し、以下のいずれかの形式で追記してください。
    - ネスト形式:
      translate_api:
        key: YOUR_GOOGLE_TRANSLATE_API_KEY
    - フラット形式:
      translate_api_key: YOUR_GOOGLE_TRANSLATE_API_KEY
- 環境変数のフォールバック（任意）:
  - `TRANSLATE_API_KEY` にAPIキーを設定すると、Credentialsより優先度は低いが利用されます。

モックモード（開発用）
- `TRANSLATE_API_MODE=mock` を設定すると、外部APIを呼ばずに `"[MOCK EN] ..."` を返します。
- それ以外のときは実APIを呼びます。APIキー未設定時はエラーとなり翻訳に失敗します。
