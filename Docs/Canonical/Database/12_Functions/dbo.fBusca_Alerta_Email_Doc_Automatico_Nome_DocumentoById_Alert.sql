SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Alerta_Email_Doc_Automatico_Nome_DocumentoById_Alert]
( 
	@Id_Alert bigint,
	@JOB varchar(16) 
)
RETURNS Varchar(MAX) 
AS
BEGIN
	Declare @ARRAYTable TABLE
	(
		ID_T int,
		ITEM_ARRAY VARCHAR(8000)
	)
	

	Declare 
		@Conteudo varchar(MAX),
		@ARRAY VARCHAR(max), 
		@DELIMITADOR VARCHAR(5),
		@S VARCHAR(max),
		@ID_DC as varchar(250),
		@ID_T as INT
	
	set @ID_T = 1
	set @DELIMITADOR = ','
	
	set @ARRAY = (select distinct replace(Doc_Anexos,';',',') from Alerta_Email_Doc_Automatico with(nolock) where ID_Alerta = @Id_Alert) 
				 
	IF LEN(@ARRAY) > 0 SET @ARRAY = @ARRAY + @DELIMITADOR 
 
	WHILE LEN(@ARRAY) > 0
	BEGIN
	   SELECT @S = LTRIM(SUBSTRING(@ARRAY, 1, CHARINDEX(@DELIMITADOR, @ARRAY) - 1))
	   INSERT INTO @ARRAYTable (ID_T,ITEM_ARRAY) VALUES (@ID_T, @S)   
	   SELECT @ARRAY = SUBSTRING(@ARRAY, CHARINDEX(@DELIMITADOR, @ARRAY) + 1, LEN(@ARRAY))
	   set @ID_T  = @ID_T + 1
	END
	
	Declare @N_CONT	VarChar(max)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for 
		select right('000' + convert(varchar(3),id_dc),3) + ' - ' + Nome_DC 
			from Tipo_Doc_Cliente 
		where ID_DC in (select convert(int,ITEM_ARRAY) from @ARRAYTable)
		
----------------------------------------------------------------------------
		open Cur_CONT
			Fetch Next From Cur_CONT Into @CONT
			While @@FETCH_STATUS = 0
			Begin
				if @N_CONT='' or @N_CONT is Null
					Begin
						Set @N_CONT=@CONT
					end
				else
					begin
						set @N_CONT=@N_CONT + '|'  + @CONT
					end
				
				Fetch Next From Cur_CONT Into @CONT
			end
		close Cur_CONT
		deallocate Cur_CONT 
		
	return @N_CONT
END









GO
