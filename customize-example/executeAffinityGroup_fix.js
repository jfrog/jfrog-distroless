function __restart(bag) {
    var who = bag.who + '|' + __restart.name;
    logger.debug(who, 'Inside');

    process.exit(1);
}
