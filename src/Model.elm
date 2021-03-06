module Model exposing (init, initCustomCardModal)

import Bootstrap.Modal as Modal
import Bootstrap.Tab as Tab
import Phases.Configuration exposing (configuration)
import Random
import Types exposing (Action, CustomCardModal, EditPlayerModal, Flags, Model, Msg, Party(..), State, Step(..))
import UndoList exposing (UndoList)


initCustomCardModal : CustomCardModal
initCustomCardModal =
    { visibility = Modal.hidden
    , role = ""
    , party = Villagers
    , steps = []
    }


initEditPlayerModal : EditPlayerModal
initEditPlayerModal =
    { playerId = Nothing
    , customMarkerLabel = ""
    , customMarkerPublic = False
    }


initState : Flags -> State
initState flags =
    { players = []
    , newPlayerName = ""
    , seed = Random.initialSeed flags.seed
    , currentPhase = configuration
    , currentStepIndex = 0
    , pool = []
    , selectedCardCategory = Tab.initialState
    , fakePool = []
    , nextNominationPosition = 1
    , stealthMode = False
    , nominationCountdownDuration = 10
    , nominationCountdownRunning = False
    , customCards = []
    , customCardModal = initCustomCardModal
    , editPlayerModal = initEditPlayerModal
    , customMarkers = []
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( UndoList.fresh <| initState flags, Cmd.none )
