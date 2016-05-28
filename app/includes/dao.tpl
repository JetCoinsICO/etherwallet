<!-- The DAO -->
<div class="tab-pane active" ng-if="globalService.currentTab==globalService.tabs.dao.id">

  <!-- TOP: The DAO -->
  <section class="row">
    <div class="col-md-9 col-sm-8">
      <h2> The DAO </h2>
      <p> Use this tab to <strong>Send DAO Tokens or Vote</strong> on a specific proposal. Learn more at <a href="http://daohub.org/" target="_blank">DAOHub</a>, <a href="https://blog.slock.it/the-art-of-the-dao-experiments-with-the-generic-dao-framework-4782f7862131#.bibozinlb" target="_blank">The Art of the DAO</a>, and <a href="https://forum.daohub.org/c/theDAO" target="_blank">DAO Hub Forums (Support, too!)</a></p>
      <a class="btn btn-info btn-sm" ng-click="globalService.currentTab=globalService.tabs.daoproposals.id">Browse & Vote on All Proposals Here</a>
    </div>
    <div class="col-md-3 col-sm-4"><img src="images/thedao-addressicon.png" width="250px" height="auto" style="margin-top: 32px;" /></div>
  </section>
  <br />

  @@if (site === 'cx' ) {
    <cx-wallet-decrypt-drtv></cx-wallet-decrypt-drtv>
  }
  @@if (site === 'mew' ) {
    <wallet-decrypt-drtv></wallet-decrypt-drtv>
  }
  <!-- / TOP: The DAO -->

  <!-- BOTTOM: The DAO -->
  <section class="row" ng-show="wallet!=null" ng-controller='theDaoCtrl'>
    <hr />
    <div class="col-sm-4">
      <h4> Account Information </h4>
      <div>
        <div id="addressIdenticon" title="Address Indenticon" blockie-address="{{wallet.getAddressString()}}" watch-var="wallet"></div>
        <br />
        <p> Account Address:
          <br /> <strong style="padding-left: 1em; display: block;" class="mono word-wrap">{{wallet.getChecksumAddressString()}}</strong>
        </p>
        <p> Account Balance:
        <br />
          <strong class="text-primary" style="margin-left: 1em"> {{token.balance}} DAO Tokens</strong>
          <br />
          <strong style="margin-left: 1em"> {{etherBalance}} Ether </strong>
          <br />
          <strong style="margin-left: 1em"> {{usdBalance}} USD </strong>
          <br />
          <strong style="margin-left: 1em"> {{eurBalance}} EUR </strong>
          <br />
          <strong style="margin-left: 1em"> {{btcBalance}} BTC </strong>
        </p>
      </div>
      <br />
    </div>

    <div class="col-sm-8">

      <div class = "btn-group">
        <a class="btn btn-primary" ng-class="curTab=='send' ? 'active' : ''" ng-click="curTab='send'"> Send DAO Tokens </a>
        <a class="btn btn-primary" ng-class="curTab=='vote' ? 'active' : ''" ng-click="curTab='vote'"> Vote on a Proposal </a>
      </div>

      <!-- Send DAO Tokens -->
      <section class="daoGetTokens clearfix" ng-show="curTab=='send'">
        <h4>Send DAO Tokens</h4>
        <div class="form-group col-xs-10">
          <label> To Address: </label>
          <input class="form-control" type="text" placeholder="0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8" ng-model="tokenTx.to" ng-change="validateAddress()"/>
          <div ng-bind-html="validateAddressStatus"></div>
        </div>
        <div class="col-xs-2 address-identicon-container">
          <div id="addressIdenticon" title="Address Indenticon" blockie-address="{{tokenTx.to}}" watch-var="tokenTx.to"></div>
        </div>
        <div class="form-group col-xs-12">
          <label>
            Amount to Send:
            <br />
          </label>
          <input class="form-control" type="text" placeholder="Amount" ng-model="tokenTx.value"/>
          <div class="radio">
            <label><input type="radio" name="currencyRadio" value="dao" ng-model="tokenTx.unit"/>DAO Tokens</label>
          </div>
          <!-- advanced option panel -->
          <section>
            <div class="form-group">
              <label> Gas: </label>
              <input class="form-control" type="text" ng-model="tx.gasLimit"/>
            </div>
          </section>
          <!-- / advanced option panel -->
        </div>
        <div class="form-group col-xs-12">
          <a class="btn btn-info btn-block" ng-click="generateTokenTx()">GENERATE TRANSACTION</a>
        </div>
        <div class="col-xs-12">
           <div ng-bind-html="validateTxStatus"></div>
        </div>
        <div class="form-group col-xs-12" ng-show="showRaw">
          <label> Raw Transaction </label>
          <textarea class="form-control" rows="4" disabled >{{rawTx}}</textarea>
          <label> Signed Transaction </label>
          <textarea class="form-control" rows="4" disabled >{{signedTx}}</textarea>
        </div>
        <div class="form-group col-xs-12" ng-show="showRaw">
          <a class="btn btn-primary btn-block" data-toggle="modal" data-target="#sendTransaction">SEND TRANSACTION</a>
        </div>
        <div class="form-group col-xs-12" ng-bind-html="sendTxStatus"></div>
      </section>
      <!--/ Send DAO Tokens -->

      <!-- Vote on a Proposal -->
      <section class="daoGetTokens" ng-show="curTab=='vote'">
        <h4>Vote on a Proposal</h4>

        <div class="form-group col-xs-12 clearfix">
          <label> Proposal ID </label>
          <input class="form-control" type="text" placeholder="0" ng-model="proposalId"/>
        </div>
        <div class="form-group col-xs-12 clearfix">
              <a class="btn btn-primary" ng-click="setProposal()">LOAD PROPOSAL</a>
        </div>
        <div class="form-group col-xs-12 clearfix" ng-bind-html="loadProposalStatus"></div>
        <article class="proposal-item col-xs-12" ng-show="showProposal">
          <section>
            <div class="graph-container">
              <div class="graph-unfilled" style="width:100%"></div>

              <!-- TODO! Should be the percentage of MinQuorum -->
              <div class="graph-needed"   style="width:26%"></div>

              <!-- TODO! Should be the votes Yes / total supply (NOT /QUORUM) -->
              <div class="graph-yes"      style="width:9%"></div>
              <!-- TODO! Should be the votes No / total supply (NOT /QUORUM) -->
              <div class="graph-no"       style="width:11%; left: 9%;"></div>
            </div>


            <div class="col-xs-9 clearfix">
              <!-- TODO! fix description-->
              <h4> {{objProposal.description}} </h4>
              <p>
                Proposal ID: <strong >{{objProposal.id}}</strong> &middot;
                <!-- TODO! if date is in future -->
                ends: <strong>{{objProposal.votingDeadline | date:'medium'}}</strong>
                <!-- TODO! if date is in past -->
                ended: <strong>{{objProposal.votingDeadline | date:'medium'}}</strong>
              </p>
            </div>
            <div class="col-xs-3 clearfix text-right">
              <h4> {{objProposal.amount | number:4}} </h4>
              <p>  ETH  </p>
            </div>
          </section>
          <section class="proposal-expanded col-xs-12" style="display:block;">
            <table class="table">
              <tr>
                <td class="label">Votes Yea:</td>
                <!-- TODO! fix if nan-->
                <td class="output votes-yes">{{objProposal.yeaPer}}% <em>({{objProposal.yea}})</em></td>
              </tr>
              <tr>
                <td class="label">Votes Nay:</td>
                <!-- TODO! fix nan-->
                <td class="output votes-no">{{objProposal.nayPer}}% <em>({{objProposal.nay}})</em></td>
              </tr>
              <tr>
                <td class="label">Quroum:</td>
                <td class="output">
                  <div class="votes-needed">
                  <!-- TODO! make this work -->
                  <em>
                  total raised: {{ token.totRaised }}
                  <br />
                  total WEI Raised: {{ objProposal.totWeiRaised }}
                  <br />
                  {{ (objProposal.yea + objProposal.nay)*100 / objProposal.totWeiRaised | number:2 }}%
                  <br />
                  of
                  <br />
                  {{ objProposal.minQuroum()*100 / objProposal.totWeiRaised | number:2}}%
                  <br />
                  minQuorum: {{objProposal.minQuroum()}}
                  </em></div>
                </td>
              </tr>

              <tr>
                <td class="label">Recipient:</td>
                <td class="output"> <div class="address-identicon-container small"><div id="addressIdenticon" title="Address Indenticon" blockie-address="{{objProposal.recipient}}" watch-var="objProposal"></div></div>
                {{objProposal.recipient}} </td>
              </tr>

              <tr>
                <td class="label">Creator:</td>
                <td class="output"><div class="address-identicon-container small"><div id="addressIdenticon" title="Address Indenticon" blockie-address="{{objProposal.creator}}" watch-var="objProposal"></div></div>
                {{objProposal.creator}}</td>
              </tr>

              <!-- TODO! The open for each proposal should be
                1: Yes
                2: Yes
              -->
              <tr>
                <td class="label">Open:</td>
                <td class="output"><span ng-class="objProposal.open ? 'boolean-yes' : 'boolean-no'"> {{objProposal.open}} </span></td>
              </tr>

              <!-- TODO! The pass for each proposal should be
                1: No
                2: Yes
              -->
              <tr>
                <td class="label">Proposal Passed:</td>
                <td class="output"><span ng-class="objProposal.proposalPassed ? 'boolean-yes' : 'boolean-no'"> {{objProposal.proposalPassed}} </span></td>
              </tr>

              <!-- TODO! the hash for each proposal should be:
                1: 0x8bfe36d7a56132816b1574291cd4d675f3e7abda610c3c50228e5bf15b036ff6
                2: 0x332bb591b0f77251124f30f1a9675590bfd1cadcdf12714e731370d41a8803a3
              -->
              <tr>
                <td class="label">Proposal Hash:</td>
                <td class="output">{{objProposal.proposalHash}}</td>
              </tr>
              <tr>

              <!-- TODO! the deposit for each proposal should be:
                1: 1000000000000000
                2: 0
              -->
                <td class="label">Proposal Deposit:</td>
                <td class="output">{{objProposal.proposalDeposit}}</td>
              </tr>

              <!-- TODO! the curator for each proposal should be:
                1: NO
                2: YES
              -->
              <tr>
                <td class="label">New Curator:</td>
                <td class="output"><span ng-class="objProposal.split ? 'boolean-yes' : 'boolean-no'"> {{objProposal.split}} </span></td>
              </tr>

            </table>
            <div class="form-group">
              <a class="btn btn-primary" data-toggle="modal" data-target="#voteProposal">VOTE ON THIS PROPOSAL</a>
            </div>
            <div class="form-group col-xs-12" ng-bind-html="voteTxStatus"></div>
            <div class="form-group col-xs-12" ng-bind-html="sendTxStatus"></div>
          </section>
        </article>
      </section>
      <!-- / Vote on a Proposal -->

    </div>
  <!-- / BOTTOM: The DAO -->


  <!-- Send Modal -->
  <div class="modal fade" id="sendTransaction" tabindex="-1" role="dialog" aria-labelledby="sendTransactionLabel">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h3 class="modal-title" id="myModalLabel"> <strong class="text-danger">Warning!</strong></h3>
        </div>
        <div class="modal-body">
          <h4>
            You are about to send
            <strong id="confirmAmount" class="text-primary"> {{tokenTx.value}} </strong>
            <strong id="confirmCurrancy" class="text-primary"> DAO Token </strong>
            to address
            <strong id="confirmAddress" class="text-primary"> {{tokenTx.to}} </strong>
          </h4>
          <h4> Are you <span class="text-underline">sure</span> you want to do this?</h4>
        </div>
        <div class="modal-footer text-center">
          <button type="button" class="btn btn-default" data-dismiss="modal">No, get me out of here!</button>
          <button type="button" class="btn btn-primary" ng-click="sendTx()">Yes, I am sure! Make transaction.</button>
        </div>
      </div>
    </div>
  </div>
  <!-- / Send Modal -->

  <!-- Vote Modal -->
  <div class="modal fade" id="voteProposal" tabindex="-1" role="dialog" aria-labelledby="sendTransactionLabel">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body">

          <br />
          <h4>You are about to vote on Proposal <strong>#{{objProposal.id}}</strong>: {{objProposal.description}}.</h4>
          <h4 class="text-light">Please vote carefully, there are no do-overs or take-backs.</h4>

          <div class="row">
            <div class="col-sm-4 marg-v-md">
              <button type="button" class="btn btn-block btn-danger" ng-click="generateVoteTx(false)">VOTE NO</button>
            </div>
            <div class="col-sm-4 marg-v-md">
              <button type="button" class="btn btn-block btn-default" data-dismiss="modal">GET ME OUT OF HERE</button>
            </div>
            <div class="col-sm-4 marg-v-md">
              <button type="button" class="btn btn-block btn-primary" ng-click="generateVoteTx(true)">VOTE YES</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
    </section>
  <!-- / Vote Modal -->


</div>
<!-- / The DAO -->
