exports.handler = async (event) => {
   
    var urls = ["https://www.youtube.com/embed/kCl9j9POsJ4",
                "https://www.youtube.com/embed/k_indcC331o",
                "https://www.youtube.com/embed/BgKDHAz7PWM",
                "https://www.youtube.com/embed/SGhEhJVc3SU"];
     const response = {
        statusCode: 200,
        body: JSON.stringify(urls),
    };
    return response;
};
