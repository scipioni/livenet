export class Sessions {
    constructor() {
        this._sessionsButton = document.querySelector("#sessions-button");
        this._sessionsDropdown = document.querySelector("#sessions-dropdown");
        this._sessionLabel = document.querySelector("#sessions-button > .text");
        this._selectedSession = null;
        this._sessionsObject = [];

        this.init();
    }
    getSelectedSession() {
        return this._selectedSession;
    }
    updateSessionLabel() {
        if (!this._sessionLabel)
            return;
        this._sessionLabel.innerText = this._selectedSession?.name ?? "";
    }
    updateOnStartup() {
        if (!this._sessionsObject)
            return;

        let sessionKey = window.accounts.getDefaultAccount()?.session;
        console.log(`sessionKey: ${sessionKey}`);
	if (!sessionKey && this._sessionsObject.length > 0)
            sessionKey = this._sessionsObject[0].key;
        if (!sessionKey)
            sessionKey = window.lightdm?.default_session;
        this._selectedSession =
            this._sessionsObject.find((el) => el.key == sessionKey) ?? null;
        this.updateSessionLabel();
	
        console.log(`_selectedSession: ${this._selectedSession.name}`);
    }
   
    setSessionList() {
        const form = document.getElementById("session");
        console.log(form); 

        for (const v of this._sessionsObject){
            const name = v.name
	    // build DIV
            let div = document.createElement('div');
            div.setAttribute('class', 'radio')

	    // BUILD THE LABEL
            let label = document.createElement('label');	
            label.textContent = name;

            // BUILD THE RADIO
	    let radio = document.createElement('input');
	
	    radio.setAttribute('class', 'radio');
            radio.setAttribute('type', 'radio');
            radio.setAttribute('value', name);
            radio.setAttribute('id', name);
            
            if (window.lightdm?.default_session == v.key) {
	        radio.setAttribute('checked', 'checked')
	    }

            div.appendChild(radio);
            div.appendChild(label);
            radio.setAttribute('name', "session");

	    form.appendChild(div);
        }

        document.querySelector("#session")?.addEventListener("click", (ev) => {
            if(typeof(ev.target.id) === 'string' && ev.target.id.length !== 0) {
                // cerca la sessione corrispondente al radiobutton selezionato
                this._selectedSession=this._sessionsObject.find((el) => el.name == ev.target.id) ?? null;
                ev.stopPropagation();
            }
        });


    }

    _setSessionList() {
        if (!this._sessionsDropdown || !this._sessionsObject)
            return;
        this._sessionsDropdown.innerHTML = "";
        for (const v of this._sessionsObject) {
            const name = v.name;
            const li = document.createElement("li");
            const button = document.createElement("button");
            button.innerText = name;
            button.addEventListener("click", () => {
                this._selectedSession = v;
                this.updateSessionLabel();
            });
            li.appendChild(button);
            this._sessionsDropdown.appendChild(li);
        }
    }
    setKeydown() {
        this._sessionsDropdown?.addEventListener("keydown", (ev) => {
            if (ev.keyCode == 27) {
                this._sessionsDropdown?.classList.add("hide");
                this._sessionsButton?.focus();
            }
        });
    }
    setButton() {
        document.querySelector("#screen")?.addEventListener("click", (ev) => {
            if (!this._sessionsDropdown)
                return;
            if (ev.target == this._sessionsButton ||
                ev.target.parentElement == this._sessionsButton) {
                this._sessionsDropdown.classList.toggle("hide");
            }
            else if (ev.target != this._sessionsDropdown &&
                ev.target.closest(".dropdown") == null) {
                this._sessionsDropdown.classList.add("hide");
            }
        });
        document.querySelector("#screen")?.addEventListener("focusin", () => {
            if (!this._sessionsDropdown)
                return;
            if (!this._sessionsDropdown.contains(document.activeElement) &&
                document.activeElement != this._sessionsButton) {
                this._sessionsDropdown.classList.add("hide");
            }
        });
    }
    init() {
        if (!window.lightdm)
            return;
        this._sessionsObject = window.lightdm.sessions;
        this.updateOnStartup();
        this.setSessionList();
        this.setButton();
        this.setKeydown();
    }
}
//# sourceMappingURL=sessions.js.map
