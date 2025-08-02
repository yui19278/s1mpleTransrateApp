class TranslationsController < ApplicationController
    def new
    end
    def create
    end
    def index
        # 履歴全表示
        @translations = Translation.all
    end
end
