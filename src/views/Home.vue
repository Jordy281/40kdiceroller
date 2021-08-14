<template>
  <div>
    <header class="text-center text-white masthead"
      :style = "{backgroundImage: 'url(' + require('@/assets/img/background.jpg') + ')'}"
      style="transform-origin: center;background-position: center center;background-size: cover;">
        <div class="masthead-content">
            <div class="container">
                <h4 class="masthead-heading mb-0">For in the Grim Darkness of the Far Future... There is Only WAR</h4>
            </div>
        </div>
    </header>
    <section id="rollsimulatorheader">
        <div></div>
    </section>
    <section id="armyselector" v-if="selectArmy">
        <div class="container">
            <div class="row align-items-start">
                <div class="col-lg-12 order-lg-2">
                    <div class="p-5">
                        <h2>Rosters</h2>
                        <p>You can either upload your .ros file from BS or use the default Indomitus armies</p>
                        <div class="row align-items-start" v-if="uploadRosterFlag">
                            <div class="col-lg-12 order-lg-2">
                                <div class="p-5">
                                    <h2>Upload Rosters from Battle Scribe</h2>
                                    <p></p>
                                    <div class="row">
                                        <div class="col">
                                            <div class="row">
                                                <div class="col">
                                                    <h3>Army 1</h3>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col">
                                                    <v-file-input
                                                      label="File input"
                                                      @change="selectFirstFile"
                                                      v-model="firstArmyFile"
                                                    ></v-file-input>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col">
                                                    {{ army1UploadMessage }}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col">
                                            <div class="row">
                                                <div class="col">
                                                    <h3>Army 2</h3>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col">
                                                    <v-file-input
                                                      label="File input"
                                                      @change="selectSecondFile"
                                                      v-model="secondArmyFile"
                                                    ></v-file-input>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col">
                                                    {{ army2UploadMessage }}
                                                </div>
                                            </div>
                                        </div>
                                    </div><v-btn class="mr-2" @click="useIndomitus()">Use Indomitus</v-btn><v-btn @click="processRosters()" :disabled="!bothArmiesUploaded">Next</v-btn>
                                </div>
                            </div>
                        </div>
                        <div class="row align-items-start" v-else>
                            <div class="col-lg-12 order-lg-2">
                                <div class="p-5"><v-btn class="mr-2" @click="uploadRosterFlag = true">Upload Roster</v-btn><v-btn @click="useIndomitus()">Use Indomitus</v-btn></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section id="rollsimulator" v-else>
      <div class="container">
          <div class="row align-items-start">
              <div class="col-lg-6 order-lg-2">
                  <div class="p-3">
                      <h2>Phase</h2>
                      <div class="row">
                          <div class="col-lg-2 col-xl-2">
                              <p>Combat Type:</p>
                          </div>
                          <div class="col-lg-6 col-xl-5">
                            <v-select
                              v-model="combatType"
                              :items="combatTypes"
                              outlined
                              dense
                            ></v-select>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
      <div class="container">
            <div class="row align-items-start">
                <div class="col-lg-6 order-lg-2">
                    <div class="p-3">
                        <h2>Attacker</h2>
                        <div class="row">
                            <div class="col-lg-3 col-xl-2">
                                <p>Army:</p>
                            </div>
                            <div class="col-lg-6 col-xl-5">
                              <v-select
                                v-model="attackerArmy"
                                name="attackerArmy"
                                :items="armies"
                                item-text="name"
                                return-object
                                outlined
                                dense
                              ></v-select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3 col-xl-2">
                                <p>Unit:</p>
                            </div>
                            <div class="col-lg-6 col-xl-5">
                              <v-select
                                v-model="attackerUnit"
                                :items="attackerArmy.roster"
                                item-text="$.name"
                                return-object
                                outlined
                                dense
                              ></v-select>
                            </div>
                            <div class="col-lg-1 col-xl-1">
                                <p>x</p>
                            </div>
                            <div class="col-lg-2 col-xl-2">
                              <v-text-field
                                v-model="numberOfModels"
                                outlined
                                dense
                              ></v-text-field>
                            </div>
                        </div>
                        <div class="row">
                          <div class="row">
                            <div class="col-lg-3 col-xl-2">
                                <p>Weapon:</p>
                            </div>
                            <div class="col-lg-6 col-xl-5">
                              <v-select
                                v-model="attackerWeapon"
                                :items="attackerWeapons"
                                item-text="name"
                                return-object
                                outlined
                                dense
                              ></v-select>
                            </div>
                          </div>
                          <div class="row">
                            <v-alert
                              dense
                              outlined
                              type="error"
                              v-if="(this.combatType === '') && (this.attackerUnit !== '')"
                            >
                              Select a combat phase to view compatible weapons
                            </v-alert>
                            <v-alert
                              dense
                              outlined
                              type="info"
                              v-if="(this.weaponType === 'Grenade')"
                            >
                              Only one model per unit can attack using the grenade
                            </v-alert>
                            <v-checkbox
                              v-if="this.weaponType === 'Rapid Fire'"
                              v-model="weaponAbility"
                              :label="`Is the unit within rapid fire distance of ${rapidFireDistance.toString()}`"
                            ></v-checkbox>
                            <v-checkbox
                              v-if="this.weaponType === 'Heavy'"
                              v-model="weaponAbility"
                              label="Is this unit INFANTRY and did this unit move this turn?"
                            ></v-checkbox>
                            <v-checkbox
                              v-if="this.weaponType === 'Assault'"
                              v-model="weaponAbility"
                              label="Did this unit advance this turn?"
                            ></v-checkbox>
                            <v-text-field
                              v-if="this.isBlast"
                              v-model="modelsInDefendingUnit"
                              type="number"
                              label="How many models are in the defending unit?"
                              outlined
                              dense
                            ></v-text-field>
                          </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 order-lg-2">
                    <div class="p-3">
                        <h2>Defender</h2>
                        <div class="row">
                            <div class="col-lg-3">
                                <p>Army:</p>
                            </div>
                            <div class="col-lg-7">
                              <v-select
                                v-model="defenderArmy"
                                :items="armies"
                                item-text="name"
                                return-object
                                outlined
                                dense
                              ></v-select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-3">
                                <p>Unit:</p>
                            </div>
                            <div class="col-lg-7"><v-select
                                v-model="defenderUnit"
                                :items="defenderArmy.roster"
                                item-text="$.name"
                                return-object
                                outlined
                                dense
                              ></v-select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
      </div>
      <div class="container">
          <div class="row align-items-start">
              <div class="col">
                  <div class="p-3">
                      <h2>Modifiers</h2>
                      <div class="row">
                          <div class="col-lg-1 col-xl-2">
                              <p>Hit:</p>
                          </div>
                          <div class="col-lg-2 col-xl-2">
                            <v-text-field
                              v-model="hitRollModifier"
                              outlined
                              dense
                            ></v-text-field>
                          </div>
                          <div class="col-lg-2 col-xl-2">
                              <p>Wound:</p>
                          </div>
                          <div class="col-lg-2 col-xl-2">
                            <v-text-field
                              v-model="woundRollModifier"
                              outlined
                              dense
                            ></v-text-field>
                            </div>
                          <div class="col-lg-2 col-xl-2">
                              <p>Save:</p>
                          </div>
                          <div class="col-lg-2 col-xl-2">
                            <v-text-field
                              v-model="saveRollModifier"
                              outlined
                              dense
                            ></v-text-field>
                          </div>
                      </div>
                      <div class="btn-group" role="group" style="margin: 10px;">
                        <v-btn class="mr-2">CLEAR</v-btn>
                        <v-btn class="mr-2 primary" @click="engage()">ENGAGE<v-icon>mdi-fencing</v-icon></v-btn></div>
                  </div>
              </div>
              <div class="col">
                  <div id="outcome" class="p-3">
                      <h2>Outcome</h2>
                      <div v-if="outcome">
                        <div class="row">
                          <p><strong>{{ attackerUnit.$.name }}</strong> attacks <strong>{{ defenderUnit.$.name }} </strong>and delivers <strong>{{ wounds }}</strong> wounds</p>
                        </div>
                        <div class="row">
                          <v-dialog
                            v-model="dialog"
                            width="500"
                          >
                            <template v-slot:activator="{ on, attrs }">
                              <v-btn
                                color="red lighten-2"
                                dark
                                v-bind="attrs"
                                v-on="on"
                              >
                                Roll Breakdown
                              </v-btn>
                            </template>

                            <v-card>
                              <v-card-title class="text-h5 grey lighten-2">
                                Roll Breakdown
                              </v-card-title>

                              <v-card-text>
                                <p>Number of Attacks: {{ rollBreakdown.numberOfAttacks}} </p>
                                <p>Rolling {{ rollBreakdown.numberOfAttacks }}, hitting on {{ rollBreakdown.hitsOn }}+ -> <b>{{ rollBreakdown.numberOfHits }} hit</b></p>
                                <p>Rolling {{ rollBreakdown.numberOfHits }}, S{{ this.rollBreakdown.attackerStrength }} and T{{ this.rollBreakdown.defenderToughness }}, wounding on {{ rollBreakdown.woundsOn }}+ -> <b>{{ rollBreakdown.numberOfWounds }} wound</b></p>
                                <p>Rolling {{ rollBreakdown.numberOfWounds }}, with a save of {{ this.rollBreakdown.unmodifiedSave }}+ and AP {{ this.rollBreakdown.ap }}, saving on {{ this.rollBreakdown.savesOn }}+ -> <b>{{ rollBreakdown.numberNotSaved }} not saved</b></p>
                                <p>With weapon damage {{ rollBreakdown.weaponDamage }}, <b>{{ this.rollBreakdown.woundsInflicted }} wounds are inflicted</b></p>
                              </v-card-text>

                              <v-divider></v-divider>

                              <v-card-actions>
                                <v-spacer></v-spacer>
                                <v-btn
                                  color="primary"
                                  text
                                  @click="dialog = false"
                                >
                                  Done
                                </v-btn>
                              </v-card-actions>
                            </v-card>
                          </v-dialog>
                        </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
    </section>
    <section id="cheatsheetheader"
      :style = "{backgroundImage: 'url(' + require('@/assets/img/background.jpg') + ')'}"
      style="transform-origin: center; background-position: center center; background-size: cover;">>
        <div class="text-center d-md-flex d-lg-flex justify-content-md-center align-items-md-center justify-content-lg-center align-items-lg-center" style="height: 151px;">
            <h1 class="text-center text-white d-md-flex align-content-center justify-content-md-center align-items-md-center" style="height: 87px;">Cheat Sheet</h1>
        </div>
    </section>
    <section id="cheatsheet">
        <div class="container">
            <div class="row">
                <div class="col">
                    <div></div>
                    <p>Special thanks to&nbsp;<a href="https://www.reddit.com/user/PhantomPhixer/">u/PhantomPhixer</a>&nbsp;for providing the cheat sheet<br></p>
                </div>
                <div class="col">
                    <div></div>
                    <p></p>
                </div>
            </div>
            <div class="row"><div class="col">
<div class="embed-responsive embed-responsive-4by3">
            <vue-pdf-embed source="./WH40k_9thEd_CheatSheet.pdf" />
        </div>
</div></div>
        </div>
    </section>
    <section id="terrainheader"
      :style = "{backgroundImage: 'url(' + require('@/assets/img/background.jpg') + ')'}"
      style="transform-origin: center; background-position: center center; background-size: cover;">
        <div class="text-center d-md-flex d-lg-flex justify-content-md-center align-items-md-center justify-content-lg-center align-items-lg-center" style="height: 151px;">
            <h1 class="text-center text-white d-md-flex align-content-center justify-content-md-center align-items-md-center" style="height: 87px;">Useful Links</h1>
        </div>
    </section>
    <section id="terrain">
      <div class="container">
          <div class="row"><div class="col">
            <p> Some Useful Links when getting started with 40k </p>
            <v-list-item two-line href="https://wahapedia.ru/wh40k9ed/the-rules/playing-this-game">
              <v-list-item-content>
                <v-list-item-title>Wahapedia</v-list-item-title>
                <v-list-item-subtitle>The Wikipedia of Warhammer</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item two-line href="https://www.battlescribe.net">
              <v-list-item-content>
                <v-list-item-title>Battle Scribe</v-list-item-title>
                <v-list-item-subtitle>Program to help build wargaming lists</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item two-line href="https://buttscri.be">
              <v-list-item-content>
                <v-list-item-title>Butt Scribe</v-list-item-title>
                <v-list-item-subtitle>Formats Battlescribe lists into easily readable datasheets</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item two-line href="https://www.goonhammer.com/warhammer-40k-9th-edition">
            <v-list-item-content>
                <v-list-item-title>Goonhammer</v-list-item-title>
                <v-list-item-subtitle>Excellent resource that helps explain rules, strategy, and everything else with the hobby</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </div>
        </div>
      </div>
    </section>
    <section></section>
    <section>
        <div class="container">
            <div class="row">
                <div class="col">
                    <div>
                        <p>FYI - This app does not take into account any Abilities (except Blast) or special rolls like auto wound</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
  </div>
</template>

<script>
// import axios from 'axios'
// import pdf from 'vue-pdf'
import VuePdfEmbed from 'vue-pdf-embed/dist/vue2-pdf-embed'
import spaceMarinesIndomitus from 'raw-loader!@/assets/Indomitus - SM.ros'
import necronsIndomitus from 'raw-loader!@/assets/Indomitus - Necrons.ros'

export default {
  name: 'Home',
  components: {
    VuePdfEmbed
  },
  data () {
    return {
      selectArmy: true,
      firstArmyFile: '',
      army1UploadMessage: 'No File Chosen',
      firstArmy: '',
      secondArmyFile: '',
      army2UploadMessage: 'No File Chosen',
      secondArmy: '',
      uploadRosterFlag: false,
      attackerArmy: '',
      attackerUnit: '',
      numberOfModels: 0,
      attackerWeapon: '',
      defenderArmy: '',
      defenderUnit: '',
      hitRollModifier: 0,
      saveRollModifier: 0,
      woundRollModifier: 0,
      combatType: '',
      combatTypes: ['Shooting', 'Fight'],
      weaponAbility: false,
      modelsInDefendingUnit: 0,
      armies: [],
      outcome: false,
      dialog: false,
      rollBreakdown: {},
      wounds: 0
    }
  },
  computed: {
    bothArmiesUploaded () {
      return ((this.firstArmy !== '') && (this.secondArmy !== ''))
    },
    attackerWeapons () {
      var weapons = []
      if (typeof this.attackerUnit.weapons !== 'undefined') {
        for (var i = 0; i < this.attackerUnit.weapons.length; i++) {
          if ((this.combatType === 'Shooting') && (this.attackerUnit.weapons[i].type !== 'Melee')) {
            weapons.push(this.attackerUnit.weapons[i])
          } else if ((this.combatType === 'Fight') && (this.attackerUnit.weapons[i].type === 'Melee')) {
            var meleeWeapon = {}
            meleeWeapon.name = this.attackerUnit.weapons[i]
            weapons.push(this.attackerUnit.weapons[i])
          }
        }
        if (this.combatType === 'Fight') {
          var defaultAttack = {}
          defaultAttack.name = 'Default Attack'
          defaultAttack.ap = 0
          defaultAttack.s = 'user'
          defaultAttack.ws = this.attackerUnit.characteristic.ws.toString()
          defaultAttack.d = '1'
          weapons.push(defaultAttack)
        }
      }
      return weapons
    },
    weaponType () {
      const typeRegex = /(Assault)|(Rapid\sFire)|(Heavy)|(Pistol)|(Grenade)/g
      if (typeof this.attackerWeapon.type !== 'undefined') {
        const weaponArray = this.attackerWeapon.type.match(typeRegex)
        if (weaponArray.length > 0) {
          return weaponArray[weaponArray.length - 1]
        }
      }
      return ''
    },
    isBlast () {
      if ((typeof this.attackerWeapon.abilities !== 'undefined') && (this.attackerWeapon.abilities !== '')) {
        const findBlast = this.attackerWeapon.abilities.match(/Blast/g)
        if (Array.isArray(findBlast)) {
          return findBlast.length > 0
        }
      }
      return false
    },
    rapidFireDistance () {
      if (this.weaponType === 'Rapid Fire') {
        return parseInt(this.attackerWeapon.range) / 2
      }
      return 0
    }
  },
  methods: {
    engage () {
      var numberOfAttacks = 0
      var hitSkill = 0
      var attackStrength = 0
      var numberOfShotsPerModel = 0

      if (this.combatType === 'Shooting') {
        // Figure out how many hit rolls the attacker gets
        hitSkill = parseInt(this.attackerUnit.characteristic.bs)
        attackStrength = parseInt(this.attackerWeapon.s)

        // Calculate number of shots
        // find out if they have to roll for shots
        numberOfShotsPerModel = this.datasheetRolls(this.attackerWeapon.type, true)
        // Incorporate Weapon Abilities if they met the condition for the checkbox

        if ((this.weaponType === 'Rapid Fire') && (this.weaponAbility)) {
          numberOfShotsPerModel = numberOfShotsPerModel * 2
        } else if ((this.weaponType === 'Heavy') && (this.weaponAbility)) {
          hitSkill -= 1
        } else if ((this.weaponType === 'Assault') && (this.weaponAbility)) {
          hitSkill -= 1
        } else if (this.weaponType === 'Grenade') {
          this.numberOfModels = 1
        }
        // Determine number of attacks
        numberOfAttacks = this.numberOfModels * numberOfShotsPerModel
      } else if (this.combatType === 'Fight') {
        console.log('Fight!')
        console.log(this.attackerUnit.$.name + ' is fighting ' + this.defenderUnit.$.name)
        numberOfAttacks = this.numberOfModels * this.attackerUnit.characteristic.a
        hitSkill = parseInt(this.attackerUnit.characteristic.ws)
        if (this.attackerWeapon.s.toLowerCase() === 'user') {
          attackStrength = parseInt(this.attackerUnit.characteristic.s)
        } else {
          attackStrength = parseInt(this.attackerWeapon.s) + parseInt(this.attackerUnit.characteristic.s)
        }
      }

      const attackerAP = this.attackerWeapon.ap

      const defenderToughness = parseInt(this.defenderUnit.characteristic.t)
      const defenderSave = parseInt(this.defenderUnit.characteristic.sv)

      // ROLL TO HIT
      const numberOfHits = this.rollingToHit(numberOfAttacks, hitSkill)
      this.rollBreakdown.numberOfAttacks = numberOfAttacks
      this.rollBreakdown.numberOfHits = numberOfHits
      // ROLL TO WOUND
      const numberOfWounds = this.rollingToWound(numberOfHits, attackStrength, defenderToughness)
      this.rollBreakdown.numberOfWounds = numberOfWounds
      this.rollBreakdown.attackerStrength = attackStrength
      this.rollBreakdown.defenderToughness = defenderToughness
      // ROLL TO SAVE
      const numberNotSaved = this.rollingToSave(numberOfWounds, attackerAP, defenderSave)
      this.rollBreakdown.numberNotSaved = numberNotSaved
      this.rollBreakdown.ap = attackerAP
      this.rollBreakdown.unmodifiedSave = defenderSave

      // Get Damage Done
      var damage = this.datasheetRolls(this.attackerWeapon.d, false)

      this.rollBreakdown.weaponDamage = damage
      this.rollBreakdown.woundsInflicted = numberNotSaved * damage
      this.wounds = numberNotSaved * damage
      this.outcome = true
    },
    clear () {
      console.log('CLEAR')
    },
    rollDice (diceSides) {
      const result = 1 + Math.floor(Math.random() * diceSides)
      return result
    },
    rollingToHit (numberOfAttacks, attackerSkill) {
      var numberOfHits = 0
      this.rollBreakdown.hitsOn = attackerSkill - this.hitRollModifier
      new Array(numberOfAttacks).fill().map(() => {
        const dieResult = this.rollDice(6)
        if (dieResult >= attackerSkill) {
          numberOfHits++
        }
      })
      return numberOfHits
    },
    rollingToWound (numberOfHits, attackerStrength, defenderToughness) {
      var numberOfWounds = 0
      this.rollBreakdown.woundsOn = this.calculateWouldThreshold(attackerStrength, defenderToughness) - this.woundRollModifier
      new Array(numberOfHits).fill().map(() => {
        const dieResult = this.rollDice(6)
        if (dieResult >= this.rollBreakdown.woundsOn) {
          numberOfWounds++
        }
      })
      return numberOfWounds
    },
    rollingToSave (numberOfWounds, attackerAP, defenderSave) {
      this.rollBreakdown.savesOn = defenderSave - attackerAP - this.saveRollModifier
      var numberNotSaved = 0
      new Array(numberOfWounds).fill().map(() => {
        const dieResult = this.rollDice(6)
        if (dieResult < this.rollBreakdown.savesOn) {
          numberNotSaved++
        }
      })
      return numberNotSaved
    },
    calculateWouldThreshold (strength, toughness) {
      if (strength >= 2 * toughness) {
        return 2
      } else if (strength > toughness) {
        return 3
      } else if (strength === toughness) {
        return 4
      } else if (2 * strength < toughness) {
        return 6
      } else if (strength < toughness) {
        return 5
      }
      return 0
    },
    datasheetRolls (lookupText, searchAbilities) {
      // Calculate number of shots
      var totalSumOfDiceRolls = 0
      // find out if they have to roll for shots
      // We are looking for either 2D6 or D6
      const rollForMatches = lookupText.match(/\d*(d|D)\d/g)

      var doWeRoll = false
      if (Array.isArray(rollForMatches)) {
        doWeRoll = rollForMatches.length > 0
      }
      if (doWeRoll) {
        var numberOfDice = 1
        var diceSides = 6
        const rollFor = rollForMatches[rollForMatches.length - 1]
        const rollsArray = rollFor.match(/\d+/g)

        if (rollsArray.length === 2) {
          // if the number of shots is something like 2D6
          numberOfDice = rollsArray[0]
          diceSides = rollsArray[1]
        } else {
          // if the number is something like D6
          numberOfDice = 1
          diceSides = rollsArray[0]
        }

        // Roll each dice to determine how many shots each model gets
        for (var x = 0; x < numberOfDice; x++) {
          totalSumOfDiceRolls += this.rollDice(diceSides)
        }

        if (searchAbilities) {
          // if this weapon is a blast it has special abilities
          if (this.isBlast) {
            if (this.modelsInDefendingUnit > 10) {
              // make maximum number of attacks
              totalSumOfDiceRolls = numberOfDice * diceSides
            } else if (this.modelsInDefendingUnit > 5) {
              // this model cannot make less than 3 attacks
              if (totalSumOfDiceRolls < 3) {
                totalSumOfDiceRolls = 3
              }
            }
          }
        }
      } else {
        // Get number of shots per model
        const rollForMatches = lookupText.match(/\d+/g)
        totalSumOfDiceRolls = parseInt(rollForMatches[rollForMatches.length - 1])
      }
      return parseInt(totalSumOfDiceRolls)
    },
    useIndomitus () {
      var parseString = require('xml2js').parseString
      parseString(spaceMarinesIndomitus, (err, result) => {
        if (err) {
          console.log(err)
          this.army1UploadMessage = err
        } else {
          this.firstArmy = result
        }
      })
      parseString(necronsIndomitus, (err, result) => {
        if (err) {
          console.log(err)
          this.army2UploadMessage = err
        } else {
          this.secondArmy = result
        }
      })
      this.processRosters()
    },
    selectFirstFile (event) {
      if (!this.firstArmyFile) {
        this.army1UploadMessage = 'No File Chosen'
      }
      const reader = new FileReader()
      var parseString = require('xml2js').parseString
      // Use the javascript reader object to load the contents
      // of the file in the v-model prop
      reader.readAsText(this.firstArmyFile)
      reader.onload = () => {
        parseString(reader.result, (err, result) => {
          if (err) {
            console.log(err)
            this.army1UploadMessage = err
          } else {
            this.firstArmy = result
            this.army1UploadMessage = 'Uploaded Successfully'
          }
        })
      }
    },
    selectSecondFile (event) {
      if (!this.secondArmyFile) {
        this.army2UploadMessage = 'No File Chosen'
      }
      const reader = new FileReader()
      var parseString = require('xml2js').parseString
      // Use the javascript reader object to load the contents
      // of the file in the v-model prop
      reader.readAsText(this.secondArmyFile)
      reader.onload = () => {
        parseString(reader.result, (err, result) => {
          if (err) {
            this.army2UploadMessage = err
          } else {
            this.secondArmy = result
            this.army2UploadMessage = 'Uploaded Successfully'
          }
        })
      }
    },
    processRosters () {
      var army = {}
      army.name = this.firstArmy.roster.forces[0].force[0].selections[0].selection[0].selections[0].selection[0].$.name
      army.roster = this.extractUnits(this.firstArmy)
      this.armies.push(army)
      // Get Second Army
      army = {}
      army.name = this.secondArmy.roster.forces[0].force[0].selections[0].selection[0].selections[0].selection[0].$.name
      army.roster = this.extractUnits(this.secondArmy)
      // Push to Armies
      this.armies.push(army)
      // move to next phase
      this.selectArmy = false
    },
    extractUnits (army) {
      var roster = []
      var model = {}
      var allUnits = army.roster.forces[0].force[0].selections[0].selection
      for (var i = 0, x = allUnits.length; i < x; i++) {
        if (allUnits[i].$.type === 'model') {
          // The unit is a model, and the model is a unit e.g. Primaris Captain
          model = allUnits[i]
          model = this.formatModelProfile(model)
          model.weapons = this.findAllWeapons(model)
          roster.push(model)
          console.log('')
        } else if (allUnits[i].$.type === 'unit') {
          // select the squad
          var unit = allUnits[i]
          for (var j = 0, y = unit.selections.length; j < y; j++) {
            var squad = []
            var upgradedWeapons = []
            var modelHolder = unit.selections[j]
            // Go through each member of the squad
            for (var k = 0, z = modelHolder.selection.length; k < z; k++) {
              model = modelHolder.selection[k]
              // If the whole if the unit is counted a model eg. Intercessors
              if (model.$.type === 'model') {
                console.log(model.$.name)
                console.log('Type: Model')
                model = this.formatModelProfile(model)
                model.weapons = this.findAllWeapons(model)
                squad.push(model)
                console.log('')
              // Let's parse the unit for upgraded weapons eg Hellblasters/Eradicators
              } else if (model.$.type === 'upgrade') {
                console.log(model.$.name)
                console.log('Type: Upgrade')
                for (var l = 0; l < model.profiles.length; l++) {
                  var profileHolder = model.profiles[l]
                  for (var m = 0, totalProfiles = profileHolder.profile.length; m < totalProfiles; m++) {
                    // if the profile has 'weapon' as its type
                    var profile = profileHolder.profile[m]
                    if (profile.$.typeName === 'Weapon') {
                      upgradedWeapons.push(this.formatWeaponProfile(profile))
                      // upgradedWeapons.push(profile)
                      console.log('Upgrade Type: Weapon')
                      console.log('')
                    // Sometimes units are put as "upgrades" so we need to dig into the profile to get the unit type eg. Assault Intercessors
                    } else if (profile.$.typeName === 'Unit') {
                      console.log('Upgrade Type: Unit')
                      console.log('Profile: ')
                      // Profile has the characteristics for the unit
                      // model has the weapons for the unit
                      model = this.formatModelProfile(model)
                      model.weapons = this.findAllWeapons(model)
                      squad.push(model)
                      console.log('')
                    }
                  }
                }
              }
            }
            // if the squad has upgraded weapons, give it to each squad member
            if (upgradedWeapons.length > 0) {
              for (var modelNumber = 0; modelNumber < squad.length; modelNumber++) {
                if (squad[modelNumber].weapons !== undefined) {
                  squad[modelNumber].weapons = squad[modelNumber].weapons.concat(upgradedWeapons)
                } else {
                  squad[modelNumber].weapons = upgradedWeapons
                }
              }
            }
            // Add the squad to the roster
            roster = roster.concat(squad)
          }
        }
      }
      return roster
    },
    formatWeaponProfile (inputWeapon) {
      var weapon = {}
      weapon.name = inputWeapon.$.name
      for (var i = 0, x = inputWeapon.characteristics.length; i < x; i++) {
        var characteristicHolder = inputWeapon.characteristics[i]
        for (var j = 0; j < characteristicHolder.characteristic.length; j++) {
          var characteristic = characteristicHolder.characteristic[j]
          if (characteristic.$.name === 'Range') {
            weapon.range = characteristic._
          } else if (characteristic.$.name === 'Type') {
            weapon.type = characteristic._
          } else if (characteristic.$.name === 'S') {
            weapon.s = characteristic._
          } else if (characteristic.$.name === 'AP') {
            weapon.ap = characteristic._
          } else if (characteristic.$.name === 'D') {
            weapon.d = characteristic._
          } else if (characteristic.$.name === 'Abilities') {
            weapon.abilities = characteristic._
          }
        }
      }
      return weapon
    },
    formatModelProfile (model) {
      console.log('Format Model: ' + model.$.name)
      if (typeof model.profiles === 'undefined') {
        return model
      }
      if (model.profiles.length > 1) {
        console.log('MORE THAN ONE PROFILES')
        console.log(model.profiles)
      }
      if (model.profiles[0].profile.length > 1) {
        console.log('MORE THAN ONE PROFILE')
        console.log(model.profiles[0].profile)
      }
      if (model.profiles[0].profile[0].characteristics.length > 1) {
        console.log('More than one Characteristics')
        console.log(model.profiles[0].profile[0].characteristics)
      }
      model.characteristic = {}
      for (var k = 0; k < model.profiles[0].profile.length; k++) {
        var profile = model.profiles[0].profile[k]
        if (profile.$.typeName === 'Unit') {
          for (var i = 0, x = profile.characteristics.length; i < x; i++) {
            var characteristicHolder = model.profiles[0].profile[0].characteristics[i]
            for (var j = 0; j < characteristicHolder.characteristic.length; j++) {
              var characteristic = characteristicHolder.characteristic[j]
              if (characteristic.$.name === 'M') {
                model.characteristic.m = parseInt(characteristic._)
              } else if (characteristic.$.name === 'WS') {
                model.characteristic.ws = parseInt(characteristic._)
              } else if (characteristic.$.name === 'BS') {
                model.characteristic.bs = parseInt(characteristic._)
              } else if (characteristic.$.name === 'S') {
                model.characteristic.s = parseInt(characteristic._)
              } else if (characteristic.$.name === 'T') {
                model.characteristic.t = parseInt(characteristic._)
              } else if (characteristic.$.name === 'W') {
                model.characteristic.w = parseInt(characteristic._)
              } else if (characteristic.$.name === 'A') {
                model.characteristic.a = parseInt(characteristic._)
              } else if (characteristic.$.name === 'Ld') {
                model.characteristic.ld = parseInt(characteristic._)
              } else if (characteristic.$.name === 'Save') {
                model.characteristic.sv = parseInt(characteristic._)
              }
            }
          }
        }
      }
      return model
    },
    // Find all weapons in a particular model so that we may properly hash them
    findAllWeapons (model) {
      var weapons = []
      for (var x = 0; x < model.selections.length; x++) {
        // Go through each weapon
        var weaponHolder = model.selections[x]
        for (var y = 0; y < weaponHolder.selection.length; y++) {
          var weapon = weaponHolder.selection[y]
          if ((weapon.$.type === 'upgrade') && ('profiles' in weapon)) {
            for (var z = 0; z < weapon.profiles.length; z++) {
              var profileHolder = weapon.profiles[z]
              for (var zz = 0; zz < profileHolder.profile.length; zz++) {
                var profile = profileHolder.profile[zz]
                if (profile.$.typeName === 'Weapon') {
                  weapons.push(this.formatWeaponProfile(profile))
                }
              }
            }
          }
        }
      }
      return weapons
    }
  }
}
</script>
