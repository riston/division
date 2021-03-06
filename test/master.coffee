# Require dependencies
should   = require 'should'
Master   = require  __dirname + '/../lib/master'
division = require  __dirname + '/..'

############################

describe 'Class Master', ->

  ############################
  #
  # Architecture of object check
  #

  describe 'Check architecture consistency', ->

    master  = null

    before ->
      cluster = new division({ path: __dirname + '/../example/noop.js' })
      master  = do cluster.run

    after ->
      do master.destroy

    it 'should contain pid attribute', ->
      should.exist master.pid

    it 'should contain startup attribute', ->
      should.exist master.startup

    it 'should contain addSignalListener method', ->
      should.exist master.addSignalListener
      master.addSignalListener.should.be.a 'function'

    it 'should contain increase method', ->
      should.exist master.increase
      master.increase.should.be.a 'function'

    it 'should contain decrease method', ->
      should.exist master.decrease
      master.decrease.should.be.a 'function'

    it 'should contain restart method', ->
      should.exist master.restart
      master.restart.should.be.a 'function'

    it 'should contain close method', ->
      should.exist master.close
      master.close.should.be.a 'function'

    it 'should contain destroy method', ->
      should.exist master.destroy
      master.destroy.should.be.a 'function'

    it 'should contain kill method', ->
      should.exist master.kill
      master.kill.should.be.a 'function'

    it 'should contain maintenance method', ->
      should.exist master.maintenance
      master.maintenance.should.be.a 'function'

    it 'should contain publish method', ->
      should.exist master.publish
      master.publish.should.be.a 'function'

    it 'should contain broadcast method', ->
      should.exist master.broadcast
      master.broadcast.should.be.a 'function'

  ############################
  #
  # Functionality of object check
  #

  describe 'Check methods functionality', ->

    describe 'increase', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        do master.destroy

      it 'should increase number of workers (default by one)', (next) ->
        size = master.workers.length
        do master.increase

        setTimeout ->
          master.workers.length.should.be.above size
          master.workers.length.should.equal size + 1
          do next
        , 100

      it 'should increase number of workers by passed amount', (next) ->
        size = master.workers.length
        master.increase 5

        setTimeout ->
          master.workers.length.should.be.above size
          master.workers.length.should.equal size + 5
          do next
        , 100

      it 'should emit `increase` event', (next) ->
        master.once 'increase', ->
          do next

        do master.increase

      it 'should send amount of workers created in `increase` event', (next) ->
        master.once 'increase', (amount) ->
          should.exist amount
          amount.should.equal 1

          do next

        do master.increase

      it 'should return Master class for chaining possibility', ->
        master.increase().should.be.instanceof Master

    describe 'decrease', ->

      master  = null

      before (next) ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

        master.increase 15

        setTimeout next, 1000

      after ->
        do master.destroy

      it 'should decrease number of workers (default by one)', (next) ->
        size = master.workers.length
        do master.decrease

        setTimeout ->
          master.workers.length.should.be.below size
          master.workers.length.should.equal size - 1
          do next
        , 5000

      it 'should decrease number of workers by passed amount', (next) ->
        size = master.workers.length
        master.decrease 5

        setTimeout ->
          master.workers.length.should.be.below size
          master.workers.length.should.equal size - 5
          do next
        , 5000

      it 'should emit `decrease` event', (next) ->
        master.once 'decrease', ->
          do next

        do master.decrease

      it 'should send amount of workers removed in `decrease` event', (next) ->
        master.once 'decrease', (amount) ->
          should.exist amount
          amount.should.equal 1

          do next

        do master.decrease

      it 'should return Master class for chaining possibility', ->
        master.decrease().should.be.instanceof Master

    describe 'restart', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      after ->
        setTimeout master.destroy, 1000

      it 'should emit `restart` event', (next) ->
        master.once 'restart', next
        do master.restart

    describe 'close', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      it 'should emit `close` event', (next) ->
        master.once 'close', next
        do master.close

    describe 'destroy', ->

      master  = null

      before ->
        cluster = new division({ path: __dirname + '/../example/noop.js' })
        master  = do cluster.run

      it 'should emit `destroy` event', (next) ->
        master.once 'destroy', next
        do master.destroy


