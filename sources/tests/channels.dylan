Module: channels-test-suite
Author: Jason Trenouth
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      See License.txt in this distribution for details.
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

/// TO TEST:
/// actual uses in environment
/// typical uses
/// mapper

// Check channel callbacks called only once while tuned-in.
define test test-defaults--object-is-callback ()
  let channel = make(<channel>);
  let count1 = 1;
  let count2 = 2;
  local method inc-count1 (message) count1 := count1 + message end method;
  local method inc-count2 (message) count2 := count2 + message end method;

  broadcast(channel, 1);
  check-equal("Count1 not yet changed", 1, count1);
  check-equal("Count2 not yet changed", 2, count2);

  tune-in(channel, inc-count1);
  broadcast(channel, 1);
  check-equal("Count1 now 2", 2, count1);
  check-equal("Count2 not yet changed", 2, count2);

  tune-in(channel, inc-count2);
  broadcast(channel, 1);
  check-equal("Count1 now 3", 3, count1);
  check-equal("Count2 now 3", 3, count2);

  tune-out(channel, inc-count1);
  broadcast(channel, 1);
  check-equal("Count1 still 3", 3, count1);
  check-equal("Count2 now 4", 4, count2);

  tune-out(channel, inc-count2);
  broadcast(channel, 1);
  check-equal("Count1 still 3", 3, count1);
  check-equal("Count2 still 4", 4, count2);
end test;

define test test-unique-object-as-receiver-key ()
  let channel = make(<channel>);
  let object = pair(#f, #f);
  let count = 0;

  tune-in(channel, object, callback: method (message)
                                       count := count + message
                                     end);
  broadcast(channel, 1);
  check-equal("Count now 1", 1, count);

  tune-out(channel, object);
  broadcast(channel, 1);
  check-equal("Count still 1", 1, count);
end test;

define test test-no-message-passed--channel-property ()
  let channel = make(<channel>, message?: #f);
  let count = 0;
  local method inc-count ()
          count := count + 2
        end;
  tune-in(channel, inc-count);
  broadcast(channel, 1);
  check-equal("Count now 2", 2, count);
end test;

define test test-no-message-passed--receiver-property ()
  let channel = make(<channel>);
  let count = 0;
  local method inc-count ()
          count := count + 2
        end;
  tune-in(channel, inc-count, message?: #f);
  broadcast(channel, 1);
  check-equal("Count now 2", 2, count);
end test;

define test test-receiver-passed--channel-property ()
  let channel = make(<channel>, receiver?: #t);
  let object = pair(-1, -1);
  let maybe-object = #f;
  local method inc-count (message, passed-object)
          maybe-object := passed-object
        end;
  tune-in(channel, object, callback: inc-count);
  broadcast(channel, 1);
  check-equal("Receiver passed", object, maybe-object);
end test;

define test test-receiver-passed--receiver-property ()
  let channel = make(<channel>);
  let object = pair(-1, -1);
  let maybe-object = #f;
  local method set-maybe-object (message, passed-object)
          maybe-object := passed-object
        end;
  tune-in(channel, object, receiver?: #t, callback: set-maybe-object);
  broadcast(channel, 1);
  check-equal("Receiver passed", object, maybe-object);
end test;

define test test-message-type ()
  let channel = make(<channel>);
  let message = list(1);
  let maybe-message = #f;
  local method set-maybe-message (passed-message)
          maybe-message := passed-message
        end;

  tune-in(channel, set-maybe-message, message-type: <list>);
  broadcast(channel, vector(1));
  check-false("Maybe-message still #F", maybe-message);

  broadcast(channel, message);
  check-equal("Maybe-message now message", maybe-message, message);
end test;

define test test-channel-defines-callback ()
  let count = 0;
  local method inc-count (message)
          count := count + message
        end;
  let channel = make(<channel>, callback: inc-count);
  tune-in(channel, #f);
  tune-in(channel, #t);
  broadcast(channel, 1);
  check-equal("Count now 2", 2, count);
end test;

define test test-receiver-overrides-channel ()
  let count = 0;
  let receiver = #f;
  local method inc-count (message)
          count := count + message
        end;
  let channel = make(<channel>, callback: inc-count);
  tune-in(channel, #f);
  tune-in(channel, #t, message?: #f, receiver?: #t,
          callback: method (x)
                      receiver := x;
                      count := count + 9
                    end);
  broadcast(channel, 1);
  check-equal("Count now 10", 10, count);
  check-equal("Receiver now #t", #t, receiver);
end test;

define test test-broadcaster-passes-extra-arguments ()
  let channel = make(<channel>);
  let count = 0;
  local method inc-count (message, extra-arg)
          count := count + message + extra-arg
        end;
  tune-in(channel, inc-count);
  broadcast(channel, 1, 99);
  check-equal("Count now 100", 100, count);
end test;

define test test-override-channel ()
  let channel = make(<channel>);
  let count = 0;
  local method inc-count (receiver)
          count := count + receiver;
          #t
        end;
  tune-in(channel, 1);
  tune-in(channel, 2);
  let result = broadcast(override-channel(channel,
					  mapper: every?,
					  message?: #f,
					  receiver?: #t,
					  callback: inc-count),
			 #"ignored");
  check-equal("Result now #t", #t, result);
  check-equal("Count now 3", 3, count);
end test;
