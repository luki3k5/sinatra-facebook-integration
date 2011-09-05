Sinatra example for Facebook integration
=====

------  
This is a small Sinatra application to demo how to integrate with Facebook through oauth2 

Setup
-----

Setup new facebook application [here]('http://facebook.com/developers')  and point it to your webapp. </br>
Ensure that you have Canvas URL and Secure Canvas URL pointing properly to where you have your webapp hosted. (I recommend [Heroku](http://heroku.com) for testing)

Next - copy App ID and App Secret into _facebook\_app\_config.yml.template_' and rename it to '_facebook\_app\_config.yml_' 
application name is required too as the webapp resolves/builds up urls based on the name you have given to it on FB DEVELOPERS site. 

This is it you are ready to go - navigate to http://apps.facebook.com/NAME\_OF\_YOUR\_APP and you are good to go! 

License 
-----

Feel free to do whatever with this... 

 