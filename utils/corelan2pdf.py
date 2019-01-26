from pyquery import PyQuery    
import requests

url = 'https://www.corelan.be/index.php/2009/07/19/exploit-writing-tutorial-part-1-stack-based-overflows/'
response = requests.get(url)
print(response)
if response.status_code == 200:
    pq = PyQuery(response)
    tag = pq('#art-main .art-content-layout>.art-content-layout-row>.art-content.art-layout-cell .art-post.status-publish .art-post-body .art-post-inner.art-article')
    print(tag.text())
else :
    print(f"Request to {url} failed with status {response.status_code}")