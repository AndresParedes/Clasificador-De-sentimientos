
use Encode;
#use utf8;
use HTML::Entities;
use warnings;
use strict;
binmode STDOUT, ":utf8";

my ($directorio_frases, $directorio_diccionario, $directorio_tablas) = @ARGV;

if(not defined $directorio_frases or not defined $directorio_diccionario or not defined $directorio_tablas ){
	die "ERR: Faltan argumentos\nEjemplo de uso: ./perl 2.analisis.pl directorio_frases directorio_diccionario directorio_tablas \n";
}

main();

sub main {

	if (!-d "$directorio_frases") {
		die "Directorio \"$directorio_tablas\" no encontrado.\n";
	}
	
	if (!-d "$directorio_diccionario") {
		die "Directorio \"$directorio_diccionario\" no encontrado.\n";
	}

	#Verifica que exista el directorio diccionario, de no estarlo, lo crea
	if ( -d "$directorio_tablas") {
		print "Directorio \"$directorio_tablas\" encontrado.\n";
	}
	else {
		mkdir("$directorio_tablas") or die "No se puede crear el directorio tablas";
		print "Directorio \"$directorio_tablas\" creado.\n";		
	}
	
	#Variables
	my $suma;
	my $adjetivo;
	my $verbo;
	my $linea="";
	
	#Abre el directorio y guarda los nombres de los archivos en un array
	my @frasesList = &readFiles($directorio_frases);
	my @diccionarioList = &readFiles($directorio_diccionario);

	foreach my $fileName (@frasesList) {
		
		my $contenido = openFile($fileName);
		my $arf="\@relation Sentences\n\n\@attribute adjetives real\n\@attribute verbs real\n\@attribute clasificacion {positivo, negativo, neutral}\n\n\@data\n";
		
		
		#Busca oraciones que contengan palabras ambiguas
		my $salidaTxt ;
		while($contenido =~ /([^|]+)/g){
		
			$suma=0;
			$adjetivo=0;
			$verbo=0;			
			my $oracion=$1;
			
			while($oracion =~ /([a-z']+)/gi){
			my $palabra = $1;
				
				foreach my $fileName (@diccionarioList){
					my $contenidoDiccionario = openFile($fileName);
					if($contenidoDiccionario =~ /\n\b$palabra\b(?:\t([0-9]))?\n/i){
					
						if($fileName eq 'diccionario/adjPositivo.txt'){
							if(defined $1){
							$adjetivo+=$1;
							}
							else{
							$adjetivo++;
							}
							
						}
						elsif($fileName eq 'diccionario/adjNegativo.txt'){
							if(defined $1){
								$adjetivo-=$1;
							}
							else{
							$adjetivo--;
							}
							}
						elsif($fileName eq 'diccionario/verPositivo.txt'){
								if(defined $1){
								$verbo+=$1;
								}
								else{
								$verbo+=2;
							}
							
						}
						elsif($fileName eq 'diccionario/verNegativo.txt'){
							if(defined $1){
							$verbo-=$1;
							}
							
							else{
							$verbo-=2;
							}
						}
				
					}
					
				}		
			}
			$suma=$verbo+$adjetivo;
			#print "$oracion\t$suma\n";
			 my $class="";
		 $salidaTxt =$salidaTxt. "$oracion\t$suma\n";
		 if ($suma>0){
		  $class="positivo";
		 }
		 elsif($suma==0){
		  $class="neutral";
		 }
		 else{
		  $class="negativo";
		 }
		 $arf.="$adjetivo, $verbo, $class\n"
		}
		&storeNewFile($fileName, $salidaTxt);
		&storeNewFile("salida.arff", $arf);
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
   open (FILE, $fileName) or die "No se puede leer el archivo \"$fileName\" [$!]\n";
   my $fileContent = <FILE>;
   close (FILE);

   return $fileContent;
}

sub storeNewFile {
   my ($fileName, $fileContent) = @_;
   
   #Removing directory name from the inicial input.
   $fileName =  substr($fileName, index ($fileName, "/")+1, (length ($fileName) - index ($fileName, "/")+1));
   &writeFile("$directorio_tablas\\$fileName", $fileContent);
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