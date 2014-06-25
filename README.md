ByrdApp
=======

A twitter client providing you a way to manage, tweet, and feeeed.

Time spent: 14 hours spent in total

## User Stories

### Required:
* [x] User can sign in using OAuth login flow
* [x] User can view last 20 tweets from their home timeline
* [x] The current signed in user will be persisted across restarts
* [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
* [x] User can pull to refresh
* [x] User can compose a new tweet by tapping on a compose button.
* [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

### Optional:
* [ ] When composing, you should have a countdown in the upper right for the tweet limit.
* [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
* [x] Retweeting and favoriting should increment the retweet and favorite count.
* [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
* [ ] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
* [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

Walkthrough of all user stories:

![Video Walkthrough](https://raw.githubusercontent.com/NinjaSudo/ByrdApp/master/demo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

**Notes**

## Resources Used

### Pods

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
* [POP](https://github.com/facebook/pop)
* [LBBlurredImage](https://github.com/lukabernardi/LBBlurredImage)
* [TSMessages](https://github.com/toursprung/TSMessages)

### APIs

[Twitter API](https://dev.twitter.com/docs/api/1.1)

### Further Reading

* http://www.raywenderlich.com/55384/ios-7-best-practices-part-1
* http://www.raywenderlich.com/5478/uiview-animation-tutorial-practical-recipes
* http://www.raywenderlich.com/73286/top-5-ios-7-animations
* https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIScrollView_Class/Reference/UIScrollView.html#//apple_ref/occ/instm/UIScrollView/scrollRectToVisible:animated:
* http://locassa.com/animate-uitableview-cell-height-change/
* http://horseshoe7.wordpress.com/2013/05/26/hands-on-with-the-mantle-model-framework/
* https://github.com/thecodepath/ios_guides/wiki/Basic-View-Properties
* https://github.com/thecodepath/ios_guides/wiki/Adding-Image-Assets
* http://stackoverflow.com/questions/3544291/application-session-in-ios
* http://code.tutsplus.com/tutorials/ios-sdk-working-with-nsuserdefaults--mobile-6039
* https://www.youtube.com/watch?v=bJ5wtDBfF6I

#### Tinkering
* http://stackoverflow.com/questions/11908688/ios-php-login-best-practice

### Tools

* http://www.hurl.it/
* https://dev.twitter.com/console

### Credits

* Free iOS icons: http://www.glyphish.com/

## Personal Notes

* Found an issue with my user persistence that I wasn't able to debug in time for turn in.
