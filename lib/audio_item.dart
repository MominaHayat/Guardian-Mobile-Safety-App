import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';


class AudioItem extends StatefulWidget{
  const AudioItem({
    super.key,
    required this.item,
  });
  final SongModel item;

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends  State<AudioItem>{
  final AudioPlayer _player = AudioPlayer();
  bool _isPlay = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: (){
        if(_isPlay){
          _player.setAudioSource(
            AudioSource.file(widget.item.data),
          );
          _player.play();
        }else{
          _player.stop();
        }
        setState(() {
          _isPlay= !_isPlay;
        });

      },
      child: ListTile(
        title: Text(widget.item.title),
        subtitle: Text(widget.item.artist ?? 'No Artist'),
        trailing: Container(
          height: 48,
          width: 48,
          decoration:  BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 48, 128, 45),
              Color.fromARGB(255, 186, 210, 88),
            ],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,

            ),
            borderRadius: BorderRadius.circular(30),

          ),
          padding: const EdgeInsets.all(10),
          child: _isPlay ? const Icon(
            Icons.play_arrow,
            color: Colors.white,
          )
              : const Icon(
            Icons.pause,
            color: Colors.white,

          ),
        ),
        leading: QueryArtworkWidget(
            id: widget.item.id,
            type: ArtworkType.AUDIO
        ),
      ),
    );
  }

}