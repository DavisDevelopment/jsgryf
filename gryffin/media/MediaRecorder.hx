package gryffin.display;

import tannus.io.*;
import tannus.ds.*;
import tannus.geom2.*;
import tannus.html.Blobable;

import gryffin.display.Ctx;
import gryffin.display.Context;
import gryffin.display.Paintable;

import js.html.Blob in JBlob;
import js.html.FileReader;
import js.html.MediaStream;
import js.html.MediaRecorder as Rec;
import js.html.DOMException;

import Math.*;
import tannus.math.TMath.*;

using StringTools;
using tannus.ds.StringUtils;
using Slambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;
using tannus.FunctionTools;
using tannus.html.JSTools;

class MediaRecorder {
    /* Constructor Function */
    public function new(stream:MediaStream, ?options:MediaRecorderOptions):Void {
        r = new Rec(stream, untyped options);
        fr = null;
        blobs = new Array();

        dataEvent = new Signal();
        blobEvent = new Signal();
        errorEvent = new Signal();
        startEvent = new VoidSignal();
        stopEvent = new VoidSignal();
        pauseEvent = new VoidSignal();
        resumeEvent = new VoidSignal();
    }

/* === Instance Methods === */

    public inline function start(?timeSlice: Float):Void {
        r.start( timeSlice );
    }

    public inline function stop():Void {
        r.stop();
    }

    public inline function pause():Void {
        r.pause();
    }

    public inline function resume():Void {
        r.resume();
    }

    public function toggle():Void {
        switch ( state ) {
            case Recording:
                pause();

            case Paused:
                resume();

            default: ;
        }
    }

    public inline function requestData():Void {
        r.requestData();
    }

    /**
      * bind event handlers to the underlying object
      */
    private function bind():Void {
        r.addEventListener('dataavailable', function(event) {
            blobEvent.call(cast event.data);
        });
        r.addEventListener('error', function(event) {
            errorEvent.call(cast event.error);
        });
        r.addEventListener('pause', pauseEvent.fire);
        r.addEventListener('resume', resumeEvent.fire);
        r.addEventListener('start', startEvent.fire);
        r.addEventListener('stop', stopEvent.fire);
    }

/* === Computed Instance Fields === */

    public var state(get, never): MediaRecorderState;
    private inline function get_state():MediaRecorderState return r.state;

/* === Instance Fields === */

    private var dataEvent: Signal<ByteArray>;
    private var blobEvent: Signal<JBlob>;
    private var errorEvent: Signal<DOMException>;
    private var pauseEvent: VoidSignal;
    private var resumeEvent: VoidSignal;
    private var startEvent: VoidSignal;
    private var stopEvent: VoidSignal;

    private var r: Rec;
    private var fr: Null<FileReader>;
    private var blobs: Array<JBlob>;
}

typedef MediaRecorderOptions = {
    ?mimeType: String,
    ?audioBitsPerSecond: Float,
    ?videoBitsPerSecond: Float,
    ?bitsPerSecond: Float
};

@:enum
abstract MediaRecorderState (String) from String {
    var Inactive = 'inactive';
    var Recording = 'recording';
    var Paused = 'paused';
}
