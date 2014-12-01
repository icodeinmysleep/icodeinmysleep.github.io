docpadConfig =
  templateData:
    site:
      author: "John Batte"
      basePath: "/"
      description: """
        The Open Source Web Comic
        """
      email: "jbatte@gmail.com"
      keywords: """
        open source, web comic
        """
      oldUrls: [
        'icodeinmysleep.github.io'
      ]
      title: "I Code in my Sleep"
      url: "http://icodeinmysleep.com"

    getPreparedTitle: ->
      siteTitle = @site.title || @site.author
      if @document.title
        "#{@document.title} | #{siteTitle}"
      else
        siteTitle

    getPreparedDescription: ->
      @document.description or @site.description

    getPreparedKeywords: ->
      @site.keywords.concat(@document.keywords or []).join(', ')


  collections:
    pages: (database) ->
      database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])
    posts: (database) ->
      database.findAllLive({relativeOutDirPath:'posts'},[date:-1])


  events:
    serverExtend: (opts) ->
      {server} = opts
      docpad = @docpad
      latestConfig = docpad.getConfig()
      oldUrls = latestConfig.templateData.site.oldUrls or []
      newUrl = latestConfig.templateData.site.url

      server.use (req,res,next) ->
        if req.headers.host in oldUrls
          res.redirect 301, newUrl+req.url
        else
          next()

module.exports = docpadConfig
