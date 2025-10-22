package com.projet.jee.models;

import java.util.ArrayList;
import java.util.List;

public class QuestionChoixMultiple extends Question {
	private List<Choix> choixList = new ArrayList<>();

	public void addChoix(Choix c) {
	    choixList.add(c);
	}

	public List<Choix> getChoixList() {
	    return choixList;
	}

}
