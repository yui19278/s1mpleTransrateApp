class TranslationsController < ApplicationController
    def new
        @translation = Translation.new
    end
    def create
        @translation = Translation.new(translation_params)
        translated_text = TranslationAPIService.new(@translation.input_text).call

        # 返り値
        if translated_text
            @translation.translated_text = translated_text
        else
            @translation.error.add(:base, "翻訳失敗")
            Rails.logger.error("翻訳失敗")
            return render :new
        end

        # DB保存
        if @translation.save
            redirect_to translations_path, notice: "翻訳が完了しました。"
        else
            # 保存が失敗したら、入力内容を保持したままフォームを再表示
            render :new
        end
    end
    def index
        # 履歴全表示
        @translations = Translation.all
    end

    private
        def translation_params
            params.require(:translation).permit(:input_text)
        end
end
