import urllib.parse

def decode_url_encoded(input_string):
    decoded_string = urllib.parse.unquote(input_string)
    return decoded_string


