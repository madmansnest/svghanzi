# -*- coding: utf-8 -*-
from webpy import web
import zaozi
from google.appengine.ext import db

urls = (
  '/clear', 'clear',
  '/(.*)', 'compose',
)

app = web.application(urls, globals())

z = zaozi.ZaoZi()

class SVGImage(db.Model):
  data = db.TextProperty()

class compose:
  def GET(self, s):
    try:
      params = web.input(fontsize='64', fontfamily='sans-serif')
      verb, args = z.normalize_command(s)
      filekey = verb + ''.join(args) + params.fontsize + params.fontfamily
      svgimage = SVGImage.get_by_key_name(filekey)
      if not svgimage:
        data = z.compose(verb, args, params.fontsize, params.fontfamily)
        svgimage = SVGImage(key_name=filekey, data=data)
        svgimage.put()
      web.header('Content-Type','image/svg+xml')
      return svgimage.data.encode('utf-8')
    except(Exception):
      raise Teapot

class clear:
  def GET(self):
    return """<form action="/clear" method="post"><input type="submit" value="Clear cache"></form>"""
    
  def POST(self):
    for image in SVGImage.all():
      image.delete()
    return web.seeother('/')
      
class Teapot(web.HTTPError):
  def __init__(self):
    status = "418 I'm a teapot"
    headers = {'Content-Type': 'text/html'}
    web.HTTPError.__init__(self, status, headers, status)

application = app.wsgifunc()

if __name__ == '__main__':
  app.run()