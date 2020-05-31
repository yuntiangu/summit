import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_event_data.dart';
import 'event_tile.dart';
import 'calendar_event.dart';

class EventsList extends StatelessWidget {
  DateTime selectedDate;

  EventsList(this.selectedDate) {
    this.selectedDate = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventData>(
      builder: (context, eventData, child) {
        List<dynamic> selectedEvents = eventData.events[selectedDate];
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Event event = selectedEvents[index];
            return EventTile(
              eventTitle: event.name,
              longPressCallBack: () {
                eventData.deleteEvent(event);
              },
              dateTime: event.eventDateTime,
            );
          },
          itemCount: selectedEvents != null ? selectedEvents.length : 0,
        );
      },
    );
  }
}
