module.exports = (db) ->
  
  describe "Semantic analysis", (done) ->
      it 'should detect sentiment of a tweet', (done) ->
        alchemyAPI = require '../../src/lib/alchemyAPI' 
        alchemyAPI.analyzeSentiment "I am very happy", (sentiment) ->
            sentiment == "good"
          done()

      it "should detect language", (done) ->
        text = "你好，我是南京创客空间负责人郑岩峰，欢迎你来到南京，你的中文非常好，为交流增加了便捷。我们最近2周会有一次活动，在某个周末举行，时间待定。"
        languageAPI = require '../../src/lib/languageAPI' 
        languageAPI.detectLanguage text, (language) ->
          language == "zh"
          done()