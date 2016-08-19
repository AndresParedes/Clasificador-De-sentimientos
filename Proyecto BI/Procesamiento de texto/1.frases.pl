

use Encode;
use utf8;
use HTML::Entities;
use warnings;
use strict;
binmode STDOUT, ":utf8";

my ($directorio_acentuado, $directorio_frases) = @ARGV;

if(not defined $directorio_acentuado or not defined $directorio_frases){
	die "ERR: Faltan argumentos\nEjemplo de uso: ./perl 1.frases.pl directorio_acentuado directorio_frases\n";
}

main();

sub main {

	#Verifica que exista el directorio frases, de no estarlo, lo crea
	if ( -d "$directorio_frases") {
		print "Directorio \"$directorio_frases\" encontrado.\n";
	}
	else {
		mkdir("$directorio_frases") or die "No se puede crear el directorio frases";;
		print "Directorio \"$directorio_frases\" creado.\n";		
	}
	
	#Abre el directorio y guarda los nombres de los archivos en un array
	my @fileList = &readFiles($directorio_acentuado);
	
	foreach my $fileName (@fileList) {
	
		my $htmlFileContent = openFile($fileName);
		
		#Convierte en UTF-8
		$htmlFileContent = decode_entities($htmlFileContent);
		
		$htmlFileContent =~ s/,\"/\",/g;
		$htmlFileContent =~ s/\.\"/\"\./g;
		$htmlFileContent =~ s/\.\]/\]\./g;
		$htmlFileContent =~ s/[_]+//g;
		
		$htmlFileContent =~ s/\n//g;
	
		##Sustituye mas de dos espacios por uno solo
		$htmlFileContent =~ s/ {2,}/ /g;
		
		my $frases="";
		my $frase;
		
		#Busca oraciones que contengan palabras ambiguas
		while($htmlFileContent =~ /( Mrs?\.[^\.]+\.)|([^\.]+\.)/g){
			if (defined $1){
				$frase=$1." |\n";
			}
			else{
				$frase=$2." |\n";
			}
			
			$frases=$frases.$frase;
		}
		
		
		##Sustituye salto de linea seguido de espacio por salto de linea
		$frases =~ s/\n /\n/g;
		
		&storeNewFile($fileName, $frases);
		$fileName =  substr($fileName, index ($fileName, "/")+1, (length ($fileName) - index ($fileName, "/")+1));
		print "Archivo $fileName creado.\n"
	}
}

sub readFiles {
   my ($folder) = @_;
   my @files = <$folder/*>;
   return @files;
}
	
sub openFile {
   my ($fileName) = @_;
   #Lee todo el archivo en lugar de una sola línea
   local $/;
   open (FILE, "<:utf8",$fileName) or die "No se puede leer el archivo \"$fileName\" [$!]\n";
   my $fileContent = <FILE>;
   close (FILE);

   return $fileContent;
}

sub storeNewFile {
   my ($fileName, $fileContent) = @_;
   
   #Removing directory name from the inicial input.
   $fileName =  substr($fileName, index ($fileName, "/")+1, (length ($fileName) - index ($fileName, "/")+1));
   &writeFile("$directorio_frases\\$fileName", $fileContent);
}

#Crea un nuevo archivo
#Borra el contenido del archivo ya existente
sub writeFile {
   my ($fileName, $content) = @_;
   #writing content into a file.
   #open FILE, ">$fileName" or die "No se puede leer el archivo \"$fileName\" [$!]\n";
   open (FILE, ">:utf8",$fileName) or die "No se puede leer el archivo \"$fileName\" [$!]\n";
   print FILE $content;
   close (FILE);
}