//Main code edits
/datum/reagent/drug/aphrodisiacplus/overdose_process(mob/living/M)
	if(M && M.client?.prefs.arousable && !(M.client?.prefs.cit_toggles & NO_APHRO))
		if(!HAS_TRAIT(M, TRAIT_IN_HEAT))
			to_chat(M, "<span class='userlove'>Your need for sex is overpowering!</span>")
			M.log_message("Made In Heat by hexacrocin.", LOG_EMOTE)
			ADD_TRAIT(M, TRAIT_IN_HEAT, APHRO_TRAIT)
	. = ..()

//Own stuff
/datum/reagent/drug/maint/tar
	name = "Maintenance Tar"
	description = "An unknown tar that you most likely gotten from an assistant, a bored chemist... or cooked yourself."
	reagent_state = LIQUID
	color = "#000000"
	overdose_threshold = 30

/datum/reagent/drug/maint/tar/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()

	M.AdjustStun(-10 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
	M.AdjustKnockdown(-10 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
	M.AdjustUnconscious(-10 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
	M.AdjustParalyzed(-10 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
	M.AdjustImmobilized(-10 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
	M.adjustOrganLoss(ORGAN_SLOT_LIVER, 1.5 * REAGENTS_EFFECT_MULTIPLIER * delta_time)

/datum/reagent/drug/maint/tar/overdose_process(mob/living/M, delta_time, times_fired)
	. = ..()

	M.adjustToxLoss(5 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
	M.adjustOrganLoss(ORGAN_SLOT_LIVER, 3 * REAGENTS_EFFECT_MULTIPLIER * delta_time)

/datum/reagent/drug/copium
	name = "Copium"
	description = "Cope and sssethe"
	taste_description = "coping"
	color = "#0f0"
	overdose_threshold = 30
	gas = GAS_COPIUM
	value = REAGENT_VALUE_GLORIOUS

/datum/reagent/drug/copium/on_mob_life(mob/living/carbon/M)
	. = ..()

	if (!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if (prob(10))
		to_chat(H, "<span class='notice'>You feel like you can cope!</span>")
		H.adjust_disgust(-10)
		SEND_SIGNAL(H, COMSIG_ADD_MOOD_EVENT, "copium", /datum/mood_event/cope, name)
	. = 1

/datum/reagent/drug/copium/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>What the fuck.</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overdose, name)

/datum/reagent/drug/copium/overdose_process(mob/living/M)
	var/mob/living/carbon/human/H = M
	if (prob(5))
		H.adjust_disgust(20)
		to_chat(H, "<span class='warning'>I can't stand it anymore!</span>")
	..()

/datum/reagent/drug/copium/reaction_obj(obj/O, volume)
	if ((!O) || (!volume))
		return 0
	var/temp = holder ? holder.chem_temp : T20C
	O.atmos_spawn_air("copium=[volume];TEMP=[temp]")

/datum/reagent/drug/reaction_turf(turf/open/T, volume)
	if (istype(T))
		var/temp = holder ? holder.chem_temp : T20C
		T.atmos_spawn_air("copium=[volume];TEMP=[temp]")
	return


/datum/reagent/drug/genital_purity
	name = "Nope"
	taste_description = "purity"
	metabolization_rate = 0.2
	var/mod_flag = GENITAL_IMPOTENT
	var/genital

/datum/reagent/drug/genital_purity/on_mob_metabolize(mob/living/carbon/C)
	..()
	var/obj/item/organ/genital/G = C.getorganslot(genital)
	if(!G)
		return
	
	G.set_aroused_state(0, "impotence") //just so it goes down if it's a penis
	ENABLE_BITFIELD(G.genital_flags, mod_flag)

/datum/reagent/drug/genital_purity/on_mob_end_metabolize(mob/living/carbon/C)
	var/obj/item/organ/genital/G = C.getorganslot(genital)
	if(!genital)
		return
	
	DISABLE_BITFIELD(G.genital_flags, mod_flag)

	..()

/datum/reagent/drug/genital_purity/penis_purity
	name = "Penis Purity"
	color = COLOR_STRONG_VIOLET
	genital = ORGAN_SLOT_PENIS

/datum/reagent/drug/genital_purity/virtuous_vagina
	name = "Virtuous Vagina"
	color = COLOR_LIGHT_PINK
	genital = ORGAN_SLOT_VAGINA

/datum/reagent/drug/genital_stimulator
	name = "Nope"
	metabolization_rate = 0.2
	taste_description = "excitement"
	var/mod_flag = GENITAL_OVERSTIM
	var/genital

/datum/reagent/drug/genital_stimulator/on_mob_metabolize(mob/living/carbon/C)
	..()
	if(genital == "anus")
		ADD_TRAIT(C, mod_flag, ORGAN_TRAIT)
		return

	var/obj/item/organ/genital/G = C.getorganslot(genital)
	if(!G)
		return
	else
		G.genital_flags |= mod_flag

/datum/reagent/drug/genital_stimulator/on_mob_end_metabolize(mob/living/carbon/C)
	var/obj/item/organ/genital/G = C.getorganslot(genital)
	if(!genital)
		return
	
	if(G == "anus")
		REMOVE_TRAIT(C, mod_flag, ORGAN_TRAIT)
	else
		DISABLE_BITFIELD(G.genital_flags, mod_flag)

	..()

/datum/reagent/drug/genital_stimulator/anal_allure
	name = "Anal Allure"
	color = COLOR_DARK_RED
	mod_flag = TRAIT_OVERSTIM_ANUS
	genital = "anus"

/datum/reagent/drug/genital_stimulator/breast_buzzer
	name = "Breast Buzzer"
	color = COLOR_PINK
	genital = ORGAN_SLOT_BREASTS

/datum/reagent/drug/genital_stimulator/peen_pop
	name = "Peen Pop"
	color = COLOR_MOSTLY_PURE_ORANGE
	genital = ORGAN_SLOT_PENIS
