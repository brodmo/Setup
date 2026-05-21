#include QMK_KEYBOARD_H

enum my_custom_keycodes {
    LAYER_CTRL_TAB = SAFE_RANGE
};

static bool layer_ctrl_down = false;

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (keycode != LAYER_CTRL_TAB) return true;
    if (!record->event.pressed) return false;

    if (!layer_ctrl_down) {
        register_code(KC_LCTL);
        layer_ctrl_down = true;
    }
    tap_code(KC_TAB);
    return false;
}

layer_state_t layer_state_set_user(layer_state_t state) {
    if (layer_state_cmp(state, 7)) return state;

    if (layer_ctrl_down) {
        unregister_code(KC_LCTL);
        layer_ctrl_down = false;
    }
    return state;
}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // Mac
    [0] = LAYOUT_ansi_84(
        KC_ESC,       KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,  MO(3),   KC_INS,  KC_DEL,
        KC_GRV,       KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS, KC_EQL,           KC_BSPC, KC_PGUP,
        KC_TAB,       KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC, KC_RBRC,          KC_BSLS, KC_PGDN,
        LT(7,KC_ESC), KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,                   KC_ENT,  KC_HOME,
        KC_LSFT,               KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,          KC_RSFT, KC_UP,   KC_END,
        KC_LCTL,      KC_LALT, KC_LGUI,                   KC_SPC,                             KC_RGUI, KC_RALT, KC_RCTL,          KC_LEFT, KC_DOWN, KC_RGHT
    ),
    // Windows
    [2] = LAYOUT_ansi_84(
        KC_ESC,       KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,  MO(3),   KC_INS,  KC_DEL,
        KC_GRV,       KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS, KC_EQL,           KC_BSPC, KC_PGUP,
        KC_TAB,       KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC, KC_RBRC,          KC_BSLS, KC_PGDN,
        KC_CAPS_LOCK, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,                   KC_ENT,  KC_HOME,
        KC_LSFT,               KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,          KC_RSFT, KC_UP,   KC_END,
        KC_LCTL,      KC_LGUI, KC_LALT,                   KC_SPC,                             KC_RALT, KC_RGUI, KC_RCTL,          KC_LEFT, KC_DOWN, KC_RGHT
    ),
    [7] = LAYOUT_ansi_84(
        KC_MPLY,        KC_VOLD,       KC_VOLU,       _______,      _______,     _______,     _______,     _______,     _______,     _______,       _______,       _______,       _______,       KC_PSCR,       _______,       _______,
        LCAG(KC_GRV),   LCAG(KC_1),    LSA(KC_LBRC),  LSA(KC_RBRC), LCAG(KC_4),  LCAG(KC_5),  LCAG(KC_6),  LCAG(KC_7),  LCAG(KC_8),  LCAG(KC_9),    LCAG(KC_0),    LCAG(KC_MINS), LCAG(KC_EQL),                 KC_DEL,        _______,
        LAYER_CTRL_TAB, LCAG(KC_Q),    LCAG(KC_W),    LCAG(KC_E),   LCAG(KC_R),  LCAG(KC_T),  LCAG(KC_Y),  LCAG(KC_U),  C(KC_I),     LCAG(KC_O),    LCAG(KC_P),    LCAG(KC_LBRC), LCAG(KC_RBRC),                LCAG(KC_BSLS), _______,
        _______,        LCAG(KC_A),    LCAG(KC_S),    LCAG(KC_D),   LCAG(KC_F),  C(KC_G),     KC_LEFT,     KC_DOWN,     KC_UP,       KC_RGHT,       LCAG(KC_SCLN), LCAG(KC_QUOT),                               LCAG(KC_ENT),  _______,
        _______,                       LCAG(KC_Z),    LCAG(KC_X),   LCAG(KC_C),  LCAG(KC_V),  LCAG(KC_B),  LCAG(KC_N),  LCAG(KC_M),  KC_PGUP,       KC_PGDN,       LCAG(KC_SLSH),                _______,       LCAG(KC_UP),   _______,
        _______,        _______,       _______,                                  LCAG(KC_SPC),                                       _______,       _______,       _______,                      LCAG(KC_LEFT), LCAG(KC_DOWN), LCAG(KC_RGHT)
    ),
    // mostly copy paste from default keymap
    [1] = LAYOUT_ansi_84(
        _______, 	KC_BRID,   	KC_BRIU,    _______,  	_______,   	_______,   	_______,   	KC_MPRV,   	KC_MPLY,   	KC_MNXT,  	KC_MUTE, 	KC_VOLD, 	KC_VOLU,	_______,	_______,	_______,
        LNK_RF, 	LNK_BLE1,  	LNK_BLE2,  	LNK_BLE3,  	_______,   	_______,   	_______,   	_______,   	_______,   	_______,  	_______,   	_______,	_______, 				_______,	_______,
        _______, 	_______,   	_______,   	_______,  	_______,   	_______,   	_______,   	_______,   	_______,   	_______,  	_______,   	DEV_RESET,	SLEEP_MODE, 			BAT_SHOW,	_______,
        _______,	_______,   	_______,   	_______,  	_______,   	_______,   	_______,	_______,   	_______,   	_______,  	_______,	_______, 	 						_______,	_______,
        _______,				_______,   	_______,   	_______,  	_______,   	_______,   	_______,	MO(4), 		RGB_SPD,	RGB_SPI,	_______,				_______,	RGB_VAI,	_______,
        _______,	_______,	_______,										_______, 							_______,	_______,   	_______,				RGB_MOD,	RGB_VAD,    RGB_HUI
    ),
    [3] = LAYOUT_ansi_84(
        _______, 	KC_BRID,   	KC_BRIU,    _______,  	_______,   	_______,   	_______,   	KC_MPRV,   	KC_MPLY,   	KC_MNXT,  	KC_MUTE, 	KC_VOLD, 	KC_VOLU,	_______,	_______,	_______,
        LNK_RF, 	LNK_BLE1,  	LNK_BLE2,  	LNK_BLE3,  	_______,   	_______,   	_______,   	_______,   	_______,   	_______,  	_______,   	_______,	_______, 				_______,	_______,
        _______, 	_______,   	_______,   	_______,  	_______,   	_______,   	_______,   	_______,   	_______,   	_______,  	_______,   	DEV_RESET,	SLEEP_MODE, 			BAT_SHOW,	_______,
        _______,	_______,   	_______,   	_______,  	_______,   	_______,   	_______,	_______,   	_______,   	_______,  	_______,	_______, 	 						_______,	_______,
        _______,				_______,   	_______,   	_______,  	_______,   	_______,   	_______,	MO(4), 		RGB_SPD,	RGB_SPI,	_______,				_______,	RGB_VAI,	_______,
        _______,	_______,	_______,										_______, 							_______,	_______,   	_______,				RGB_MOD,	RGB_VAD,    RGB_HUI
    ),
    [4] = LAYOUT_ansi_84(
        _______, 	_______,  	_______,  	_______, 	_______,  	_______,  	_______,  	_______,  	_______,  	_______, 	_______, 	_______, 	_______, 	_______,	_______,	_______,
        _______, 	_______,   	_______,   	_______,  	_______,   	_______,   	_______,   	_______,   	_______,   	_______,  	_______,   	_______,	_______, 				_______,	_______,
        _______, 	_______,   	_______,   	_______,  	_______,   	_______,   	_______,   	_______,   	_______,   	_______,  	_______,   	_______,	_______, 				_______,	_______,
        _______,	_______,   	_______,   	_______,  	_______,   	_______,   	_______,   	_______,   	_______,   	_______,  	_______,	_______, 	 						_______,	_______,
        _______,				_______,   	_______,   	_______,  	_______,   	_______,   	_______,   	_______,   	SIDE_SPD,	SIDE_SPI,	_______,				_______,	SIDE_VAI,	_______,
        _______,	_______,	_______,										_______, 							_______,	_______,   	_______,				SIDE_MOD,	SIDE_VAD,   SIDE_HUI
    )
};
