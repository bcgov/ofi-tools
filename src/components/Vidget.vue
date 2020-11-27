<template>
  <div id="main" class="body">
    <h1>Packaged Product: &nbsp; {{ state.packName }}</h1>
    <div class="main-background">
      <strong style="font-size: 15px"
        >Email address where order notifications will be sent.
      </strong>
      <form v-on:submit.prevent="clickSubmit">
      <div class="spacer" style="margin-left: 0">
        <span
          class="twitter-typeahead"
          style="position: relative; display: inline-block"
        >
          <input
            class="tt-hint tt-back"
            type="text"
            autocomplete="off"
            spellcheck="off"
            disabled=""
          />
          <input
            type="text"
            class="bc-geocoder typeahead tt-query"
            name="emailAddress"
            autocomplete="on"
            placeholder="someone@gov.bc.ca"
            x-webkit-speech=""
            spellcheck="false"
            dir="auto"
            style="
              position: relative;
              vertical-align: top;
              background-color: transparent;
            "
            v-model="state.emailAddress"
            @focus="focusEmail"
          />
          <div style="margin-top: 40px">
            <input type="checkbox" v-model="state.condChecked" />
            <strong style="font-size: 15px; margin-left: 10px">
              I agree to the</strong
            >
            <a class="term-cond" @click="clickCond">Terms and Conditions</a>
          </div>
          <div
            v-if="state.showCond"
            class="bc-geocoder typeahead tt-query cond-text"
          >
            <div style="margin-top: 10px">
              By downloading these data products, I agree to the license terms
              and conditions as set out in each BC Data Catalogue metadata
              record.
            </div>
            <div style="margin-top: 10px">Collection Notice</div>
            <div style="margin-top: 10px">
              The personal information you post may be collected by the Ministry
              under s. 26(c) of the Freedom of Information and Protection of
              Privacy Act for the purposes of engaging and consulting with the
              public. Please be aware that any information collected may be
              stored and/or accessed outside of Canada on servers not belonging
              to the government.
            </div>
            <div style="margin-top: 10px; margin-bottom: 10px">
              Should you have any questions about the collection of your email
              address, please contact BCGov Data Distribution (DWDS) CONTACT at
              Data@gov.bc.ca, PO BOX 9864 STN PROV GOVT, Victoria BC V8W 9T5
            </div>
          </div>
          <table>
            <tr style="height: 80px">
              <td>
                <input type="submit" class="order-button" value="Submit Order" >
              </td>
              <td>
                <a style="margin-left: 20px" v-if="this.state.APILoading">
                  <i
                    style="color: #566963"
                    class="fa fa-refresh fa-spin fa-3x fa-fw"
                  ></i>
                </a>
              </td>
            </tr>
          </table>
          <div
            v-if="state.APISucc"
            class="bc-geocoder typeahead tt-query resp-ok-text"
          >
            <div style="margin-top: 10px">{{ state.ResponseText }}</div>
          </div>
          <div
            v-if="state.APIFail"
            class="bc-geocoder typeahead tt-query resp-bad-text"
          >
            <div style="margin-top: 10px">{{ state.ResponseError }}</div>
          </div>
        </span>
      </div>
      </form>
    </div>
  </div>
</template>


<script>
import axios from "axios";
import config from "../../vue.config";
// "MikeDW folder test" "MikeDW flat file test"

export default {
  name: "Vidget",
  data: function () {
    const OFI_Url = config.pluginOptions.API_OFI_ROOT;
    const CreateOrderFilteredSM =
      OFI_Url + config.pluginOptions.CreateOrderFilteredSM;
    const CreateOrderFiltered =
      OFI_Url + config.pluginOptions.CreateOrderFiltered;

    var state = {
      packName: null,
      showCond: false,
      condChecked: true,
      emailAddress: null,
      APISucc: false,
      APIFail: false,
      ResponseError: null,
      APILoading: false,
    };
    const urlParams = new URLSearchParams(window.location.search);
    var urlPackageName = urlParams.get("packagename");
    if (urlPackageName != null && urlPackageName != "") {
      state.packName = urlPackageName;
    }

    return {
      state,
      CreateOrderFilteredSM,
      CreateOrderFiltered,
    };
  },
  methods: {
    clickCond: function () {
      this.state.showCond = !this.state.showCond;
    },

    focusEmail: function () {
      this.state.APIFail = false;
    },

    isEmailValid: function () {
      const reg = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
      return this.state.emailAddress == ""
        ? false
        : reg.test(this.state.emailAddress);
    },

    clickSubmit() {
      this.state.APIFail = false;
      if (!this.state.condChecked) {
        this.state.ResponseError = "You must agree to the conditions.";
        this.state.APIFail = true;
      } else if (!this.isEmailValid()) {
        this.state.ResponseError = "Email is not valid.";
        this.state.APIFail = true;
      } else if (this.state.packName == null || this.state.packName == "") {
        this.state.ResponseError = "Package name is not valid.";
        this.state.APIFail = true;
      } else {
        this.createOrderFilteredSM(
          this.state.emailAddress,
          this.state.packName
        );
      }
    },

    createOrderFilteredSM() {
      this.state.APILoading = true;
      axios({
        method: "post",
        url: this.CreateOrderFilteredSM,
        data: {
          emailAddress: this.state.emailAddress,
          aoiType: "0",
          aoi: "",
          orderingApplication: "BCDC",
          crsType: "0",
          clippingMethodType: "1",
          formatType: "0",
          useAOIBounds: "",
          prepackagedItems: this.state.packName,
          aoiName: "",
          filterValue: "",
          filterType: "No Filter",
          pctOfMax: 5,
        },
      })
        .then((response) => {
          if (response.status == 200) {
            window.location = this.CreateOrderFiltered + response.data;
          } else {
            this.state.ResponseError =
              "Calling API Failed. Status Code: " + response.status;
            this.state.APIFail = true;
          }
        })
        .catch((error) => {
          this.state.ResponseError = error.message;
          this.state.APIFail = true;
        });
    },
  },
};
</script>


