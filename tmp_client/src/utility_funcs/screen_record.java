/* 
 * File: screen_record.java
 * Description: run system command line
 * Author: Jason.Wang
 * Date:2018/08/21
 * Modifier:
 * Date:
 * Description:
 */
package utility_funcs;


import java.awt.AWTException;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.ShortBuffer;
import java.util.Scanner;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.TargetDataLine;

import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.ffmpeg.global.avutil;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.Java2DFrameConverter;


public class screen_record {
    //screen size
	private final static int WIDTH=Toolkit.getDefaultToolkit().getScreenSize().width;
	private final static int HEIGHT=Toolkit.getDefaultToolkit().getScreenSize().height;
	//thread pool screenTimer
    private ScheduledThreadPoolExecutor screenTimer;
    //screen size
    private final Rectangle rectangle = new Rectangle(WIDTH, HEIGHT);
    //FFmpegFrameRecorder
    private FFmpegFrameRecorder recorder;
    private Robot robot;
    //thread pool exec
    private ScheduledThreadPoolExecutor exec;
    private TargetDataLine line;
    private AudioFormat audioFormat;
    private DataLine.Info dataLineInfo;
    private boolean isAudioOK = true;
    private long startTime = 0;
    private long videoTS = 0;
    private long pauseTime = 0;
    private double frameRate = 5;

    public screen_record(
    		String filePath, 
    		String fileName, 
    		boolean isAudioOK
    		) {
        // TODO Auto-generated constructor stub
        recorder = new FFmpegFrameRecorder(filePath + "/" + fileName + ".mp4", WIDTH, HEIGHT);
        // recorder.setVideoCodec(avcodec.AV_CODEC_ID_H265); // 28
        // recorder.setVideoCodec(avcodec.AV_CODEC_ID_FLV1); // 28
        recorder.setVideoCodec(avcodec.AV_CODEC_ID_MPEG4); // 13
        //recorder.setFormat("mov,mp4,m4a,3gp,3g2,mj2,h264,ogg,MPEG4");
        recorder.setFormat("mp4");
        recorder.setSampleRate(44100);
        recorder.setFrameRate(frameRate);
        recorder.setVideoQuality(0);
        recorder.setVideoOption("crf", "23");
        // 2000 kb/s, 720P good for 720
        recorder.setVideoBitrate(1000000);
        /**
         * bance quality and encode speed values 
         * ultrafast, superfast,veryfast, faster, fast, medium, slow, slower, veryslow
         * reference: https://trac.ffmpeg.org/wiki/Encode/H.264 
		 * preset ultrafast as the
         * name implies provides for the fastest possible encoding. If some tradeoff
         * between quality and encode speed, go for the speed. This might be needed if
         * you are going to be transcoding multiple streams on one machine.
         */
        recorder.setVideoOption("preset", "medium");
        recorder.setPixelFormat(avutil.AV_PIX_FMT_YUV420P); // yuv420p
        recorder.setAudioChannels(2);
        recorder.setAudioOption("crf", "0");
        // Highest quality
        recorder.setAudioQuality(0);
        recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC);
        try {
            robot = new Robot();
        } catch (AWTException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        try {
            recorder.start();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            System.out.print("*******************************");
        }
        this.isAudioOK = isAudioOK;
    }

    /**
     * start recording
     */
    public void start() {

        if (startTime == 0) {
            startTime = System.currentTimeMillis();
        }
        if (pauseTime == 0) {
            pauseTime = System.currentTimeMillis();
        }
        //if we have audio device, start audio record
        if (isAudioOK) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    // TODO Auto-generated method stub
                    caputre();
                }
            }).start();

        }
        //start video record
        screenTimer = new ScheduledThreadPoolExecutor(1);
        screenTimer.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
                BufferedImage screenCapture = robot.createScreenCapture(rectangle);
                BufferedImage videoImg = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_3BYTE_BGR);
                Graphics2D videoGraphics = videoImg.createGraphics();
                videoGraphics.setRenderingHint(RenderingHints.KEY_DITHERING, RenderingHints.VALUE_DITHER_DISABLE);
                videoGraphics.setRenderingHint(RenderingHints.KEY_COLOR_RENDERING, RenderingHints.VALUE_COLOR_RENDER_SPEED);
                videoGraphics.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_SPEED);
                videoGraphics.drawImage(screenCapture, 0, 0, null);
                Java2DFrameConverter java2dConverter = new Java2DFrameConverter();
                Frame frame = java2dConverter.convert(videoImg);
                try {
                    videoTS = 1000L
                            * (System.currentTimeMillis() - startTime - (System.currentTimeMillis() - pauseTime));
                    if (videoTS > recorder.getTimestamp()) {
                        recorder.setTimestamp(videoTS);
                    }
                    recorder.setAudioChannels(1);
                    recorder.record(frame);
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                    System.out.print("=******************************");
                }
                //release
                videoGraphics.dispose();
                videoGraphics = null;
                videoImg.flush();
                videoImg = null;
                //java2dConverter = null;
                java2dConverter.close();
                screenCapture.flush();
                screenCapture = null;
            }
        }, (int) (1000 / frameRate), (int) (1000 / frameRate), TimeUnit.MILLISECONDS);
    }

    /**
     * capture the audio
     */
    public void caputre() {
        audioFormat = new AudioFormat(44100.0F, 16, 2, true, false);
        dataLineInfo = new DataLine.Info(TargetDataLine.class, audioFormat);
        try {
            line = (TargetDataLine) AudioSystem.getLine(dataLineInfo);
        } catch (LineUnavailableException e1) {
            // TODO Auto-generated catch block
            System.out.println("#################");
        }
        try {
            line.open(audioFormat);
        } catch (LineUnavailableException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
            System.out.print("==*****************************");
        }
        line.start();
        final int sampleRate = (int) audioFormat.getSampleRate();
        final int numChannels = audioFormat.getChannels();
        int audioBufferSize = sampleRate * numChannels;
        final byte[] audioBytes = new byte[audioBufferSize];
        exec = new ScheduledThreadPoolExecutor(1);
        exec.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
                try {
                    int nBytesRead = line.read(audioBytes, 0, line.available());
                    int nSamplesRead = nBytesRead / 2;
                    short[] samples = new short[nSamplesRead];

                    // Let's wrap our short[] into a ShortBuffer and
                    // pass it to recordSamples
                    ByteBuffer.wrap(audioBytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(samples);
                    ShortBuffer sBuff = ShortBuffer.wrap(samples, 0, nSamplesRead);
                    // recorder is instance of
                    // org.bytedeco.javacv.FFmpegFrameRecorder
                    recorder.recordSamples(sampleRate, numChannels, sBuff);
                    // System.gc();
                } catch (org.bytedeco.javacv.FrameRecorder.Exception e) {
                    e.printStackTrace();
                    System.out.print("===****************************");
                }
            }
        }, (int) (1000 / frameRate), (int) (1000 / frameRate), TimeUnit.MILLISECONDS);
    }

    /**
     * stop
     */
    public void stop() {
        if (null != screenTimer) {
            screenTimer.shutdownNow();
        }
        try {
			Thread.sleep(500);
		} catch (InterruptedException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        try {
            recorder.stop();
            recorder.release();
            recorder.close();
            screenTimer = null;
            // screenCapture = null;
            if (isAudioOK) {
                if (null != exec) {
                    exec.shutdownNow();
                }
                try {
        			Thread.sleep(500);
        		} catch (InterruptedException e1) {
        			// TODO Auto-generated catch block
        			e1.printStackTrace();
        		}                
                if (null != line) {
                    line.stop();
                    line.close();
                }
                dataLineInfo = null;
                audioFormat = null;
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            System.out.println("#################");
        }
    }

    /**
     * pause
     * 
     * @throws Exception
     */
    public void pause() throws Exception {
        screenTimer.shutdownNow();
        screenTimer = null;
        if (isAudioOK) {
            exec.shutdownNow();
            exec = null;
            line.stop();
            line.close();
            dataLineInfo = null;
            audioFormat = null;
            line = null;
        }
        pauseTime = System.currentTimeMillis();
    }

    public static void main(String[] args) throws Exception, AWTException {
    	screen_record videoRecord = new screen_record("D:/tmp_work", "test", false);
        videoRecord.start();
        while (true) {
            System.out.println("Type stop/pause/start for control.");
            Scanner sc = new Scanner(System.in);
            if (sc.next().equalsIgnoreCase("stop")) {
                videoRecord.stop();
                System.out.println("Stop");
                break;
            }
            if (sc.next().equalsIgnoreCase("pause")) {
                videoRecord.pause();
                System.out.println("Pause");
            }
            if (sc.next().equalsIgnoreCase("start")) {
                videoRecord.start();
                System.out.println("Start");
            }
            sc.close();
        }
    }
}