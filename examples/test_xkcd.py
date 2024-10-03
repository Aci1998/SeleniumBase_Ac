import time
from seleniumbase import BaseCase
BaseCase.main(__name__, __file__)


class MyTestClass(BaseCase):
    def test_xkcd(self):
        self.open("https://xkcd.com/353/")
        self.assert_title("xkcd: Python")
        self.assert_element('img[alt="Python"]')
        self.click('a[rel="license"]')
        self.assert_text("free to copy and reuse")
        self.go_back()
        self.click_link("About")
        self.assert_exact_text("xkcd.com", "h2")
        self.click_link("comic #249")
        self.assert_element('img[alt*="Chess"]')


    def test_feituyun_qiandao(self):
        self.open("https://www.xn--h5qy75o.com/")

        self.type("//*[@id='regusername']", "imacaiy@outlook.com")
        self.type("//*[@id='regpassword']", "test123456")

        self.click("//*[@id='loginbox']/button")
        time.sleep(5)

        self.click("//*[@id='tangonggao']/div/button")
        self.click("/html/body/div[1]/div/div[3]/a[contains(text(),'签到得流量')]")

        time.sleep(5)
        self.click("/html/body/div[3]/div/div[2]/div[1]/div/button[contains(text(),'立即签到')]")



