import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:longa_lotto/common/blinking_animation.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/common/widget/web_view/longa_web_view.dart';
import 'package:longa_lotto/home/bloc/home_timer_bloc.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/splash/model/response/dge_game_response.dart';
import 'package:longa_lotto/splash/model/response/ige_game_response.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

import 'my_timer.dart';

part 'dge_game_card.dart';

part 'ige_game_card.dart';

part 'home_sliver_app_bar.dart';

part 'remaining_time.dart';

part 'game_timer.dart';