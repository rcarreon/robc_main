import com.twitter.conversions.storage._
import com.twitter.conversions.time._
import com.twitter.logging.config._
import com.twitter.ostrich.admin.config._
import net.lag.kestrel.config._

new KestrelConfig {
  listenAddress = "0.0.0.0"
  memcacheListenPort = 22133
  textListenPort = 2222
  thriftListenPort = 2229

  queuePath = "/app/shared/kestrel/queue"

  clientTimeout = None

  expirationTimerFrequency = 1.second

  maxOpenTransactions = 100

  // default queue settings:
  default.defaultJournalSize = 512.megabytes
  default.maxMemorySize = 384.megabytes
  default.maxJournalSize = 2.gigabyte
  default.syncJournal = 60000.milliseconds
  // default.keepJournal = false

  admin.httpPort = 2223

  admin.statsNodes = new StatsConfig {
    reporters = new TimeSeriesCollectorConfig
  }

  queues = new QueueBuilder {
    // keep items for no longer than a half hour, and don't accept any more if
    // the queue reaches 1.5M items.
    // widget_stats_views queue
    name = "widget_stats_views"
    maxMemorySize = 2048.megabytes
    defaultJournalSize = 3072.megabytes
    maxJournalSize = 9.gigabyte
    syncJournal = 60000.milliseconds
  } :: new QueueBuilder {
    // cpc_landing_page queue
    name = "cpc_landing_page"
    maxMemorySize = 2048.megabytes
    defaultJournalSize = 3072.megabytes
    maxJournalSize = 9.gigabyte
    syncJournal = 60000.milliseconds
  } :: new QueueBuilder {
    // landing_page_stats_views queue
    name = "landing_page_stats_views"
    maxMemorySize = 2048.megabytes
    defaultJournalSize = 3072.megabytes
    maxJournalSize = 9.gigabyte
    syncJournal = 60000.milliseconds
  } :: new QueueBuilder {
    // outgoing_click queue
    name = "outgoing_click"
    maxMemorySize = 1024.megabytes
    defaultJournalSize = 1536.megabytes
    maxJournalSize = 6.gigabyte
    syncJournal = 60000.milliseconds
    // name = "weather_updates"
    // maxAge = 1800.seconds
    // maxItems = 1500000
  } :: new QueueBuilder {
    // landing_page_and_widgets_clicks queue
    name = "landing_page_and_widgets_clicks"
    maxMemorySize = 1024.megabytes
    defaultJournalSize = 1536.megabytes
    maxJournalSize = 6.gigabyte
    syncJournal = 60000.milliseconds
  } :: new QueueBuilder {
    // don't keep a journal file for this queue. when kestrel exits, any
    // remaining contents will be lost.
    name = "transient_events"
    keepJournal = false
  }

  loggers = new LoggerConfig {
    level = Level.INFO
    handlers = new FileHandlerConfig {
      filename = "/app/log/kestrel/kestrel.log"
      roll = Policy.SigHup
    }
  }
}
