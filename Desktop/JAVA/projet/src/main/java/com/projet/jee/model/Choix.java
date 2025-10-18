package com.projet.jee.model;

public class Choix {
        private long id;
        private String texte;
        private boolean estCorrect;
        private long questionId;

        public Choix() {}

        public Choix(long id, String texte, boolean estCorrect, long questionId) {
                this.id = id;
                this.texte = texte;
                this.estCorrect = estCorrect;
                this.questionId = questionId;
        }

        public long getId() { return id; }
        public void setId(long id) { this.id = id; }

        public String getTexte() { return texte; }
        public void setTexte(String texte) { this.texte = texte; }

        public boolean isEstCorrect() { return estCorrect; }
        public void setEstCorrect(boolean estCorrect) { this.estCorrect = estCorrect; }

        public long getQuestionId() { return questionId; }
        public void setQuestionId(long questionId) { this.questionId = questionId; }

        @Override
        public String toString() {
                return "Choix [id=" + id + ", texte=" + texte + ", estCorrect=" + estCorrect + "]";
        }
}