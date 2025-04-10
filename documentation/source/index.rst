********
Channels
********

.. current-library:: channels

The channels library provides a thread-safe way to subscribe to channels and receive
messages, for event-driven programs.

.. note:: This documentation is just a place-holder. For now, the best way to learn how
          the Channels library works is to look at the test suite or the way it is used
          in the Open Dylan IDE.

.. toctree::
   :hidden:


The CHANNELS module
===================

.. current-module:: channels


.. class:: <channel>
   :open:

   :superclasses: :class:`<channel-object>`

   :keyword mapper: An instance of :class:`<function>`.
   :keyword receivers: An instance of :class:`<table>`.

.. generic-function:: broadcast
   :open:

   :signature: broadcast (channel message #rest args) => (#rest results)

   :parameter channel: An instance of :class:`<channel>`.
   :parameter message: An instance of :class:`<object>`.
   :parameter #rest args: An instance of :class:`<object>`.
   :value #rest results: An instance of :class:`<object>`.

.. method:: broadcast
   :specializer: <channel>, <object>

.. generic-function:: override-channel
   :open:

   :signature: override-channel (channel #rest args #key message? receiver? callback mapper) => (new-channel)

   :parameter channel: An instance of :class:`<channel>`.
   :parameter #rest args: An instance of :class:`<object>`.
   :parameter #key message?: An instance of :class:`<object>`.
   :parameter #key receiver?: An instance of :class:`<object>`.
   :parameter #key callback: An instance of :class:`<object>`.
   :parameter #key mapper: An instance of :class:`<object>`.
   :value new-channel: An instance of :class:`<channel>`.

.. method:: override-channel
   :specializer: <channel>

.. generic-function:: tune-in
   :open:

   :signature: tune-in (channel receiver-key #key #all-keys) => ()

   :parameter channel: An instance of :class:`<channel>`.
   :parameter receiver-key: An instance of :class:`<object>`.

.. method:: tune-in
   :specializer: <channel>, <object>

.. generic-function:: tune-out
   :open:

   :signature: tune-out (channel receiver-key) => ()

   :parameter channel: An instance of :class:`<channel>`.
   :parameter receiver-key: An instance of :class:`<object>`.

.. method:: tune-out
   :specializer: <channel>, <object>
