#!/opt/local/bin/python2.7
# -*- coding: utf-8 -*-

import tesseract
import tornado.ioloop
import tornado.web
import tornado.options
import time
import StringIO
import sys
import os
from PIL import Image
import cv2
import cv2.cv as cv
import json

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")

class OcrHandler(tornado.web.RequestHandler):
    def post(self):

        fileBody = self.request.files['image'][0]['body']
        img = Image.open(StringIO.StringIO(fileBody))
        seq = 0
        path = "./ocr-images/" + str(int(time.time())) + "-" + str(seq) + "." + str(img.format).lower()

        while os.path.exists(path):
            seq += 1
            path = "./ocr-images/" + str(int(time.time())) + "-" + str(seq) + "." + str(img.format).lower()

        img.save(path, img.format)
        api = tesseract.TessBaseAPI()
        api.Init(".","eng",tesseract.OEM_DEFAULT)
        api.SetVariable("tessedit_char_whitelist", "0123456789ABCDEFGHIJKLMNOPQRSTUVMXYZabcdefghijklmnopqrstuvwxyz")
        api.SetPageSegMode(tesseract.PSM_AUTO)

        image0=cv2.imread(path, cv2.CV_LOAD_IMAGE_GRAYSCALE)
    
        threshold = 127
        image0 = cv2.threshold(image0, threshold, 255, cv2.THRESH_BINARY)[1]
        height,width = image0.shape

        #cv2.namedWindow("Test")
        #cv2.imshow("Test", image0)
        #cv2.waitKey(0)
        #cv2.destroyWindow("Test")

        iplimage = cv.CreateImageHeader((width,height), cv.IPL_DEPTH_8U, 1)
        cv.SetData(iplimage, image0.tostring(),image0.dtype.itemsize * 1 * (width))
        tesseract.SetCvImage(iplimage,api)

        tesseract.SetCvImage(iplimage,api)
        resObj = dict()

        resObj['text'] = api.GetUTF8Text().replace("\n", " ")
        resObj['confidence'] = api.MeanTextConf()


        print resObj

        self.set_header("Content-Type", "application/json")
        self.write(json.dumps(resObj))
        self.finish()

application = tornado.web.Application([
    (r"/", MainHandler),
    (r"/ocr", OcrHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.options.parse_command_line()
    tornado.ioloop.IOLoop.instance().start()

