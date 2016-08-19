
use Encode;
#use utf8;
use HTML::Entities;
use warnings;
use strict;
binmode STDOUT, ":utf8";

my ($directorio_unclass, $directorio_result, $directorio_class) = @ARGV;

if(not defined $directorio_unclass or not defined $directorio_result ){
	die "ERR: Faltan argumentos\nEjemplo de uso: ./perl 4.salid.pl directorio_unclass directorio_class  \n";
}

main();

sub main {

	if (!-d "$directorio_unclass") {
		die "Directorio \"$directorio_unclass\" no encontrado.\n";
	}
	
	if (!-d "$directorio_result") {
		die "Directorio \"$directorio_result\" no encontrado.\n";
	}

	#Verifica que exista el directorio diccionario, de no estarlo, lo crea
	if ( -d "$directorio_class") {
		print "Directorio \"$directorio_class\" encontrado.\n";
	}
	else {
		mkdir("$directorio_class") or die "No se puede crear el directorio tablas";
		print "Directorio \"$directorio_class\" creado.\n";		
	}
	
	#Variables

	
	#Abre el directorio y guarda los nombres de los archivos en un array
	my @unclass = &readFiles($directorio_unclass);
	my @result = &readFiles($directorio_result);
    my $contenido1;
	foreach my $fileName1(@result){
	   $contenido1 = openFile($fileName1);
	}
	
	foreach my $fileName (@unclass) {
		
		my $contenido = openFile($fileName);
		
	    my @arregloRest = split("\n",$contenido1);
		
		foreach my $valorResultado(@arregloRest){
		
		$contenido=~s/(\?)/$valorResultado/;
		
		}
	
		&storeNewFile($fileName, $contenido);
		#&storeNewFile("libro2.arff", $arf);
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
   &writeFile("$directorio_class\\$fileName", $fileContent);
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