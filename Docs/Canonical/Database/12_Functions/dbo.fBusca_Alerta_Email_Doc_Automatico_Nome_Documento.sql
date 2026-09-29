SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBusca_Alerta_Email_Doc_Automatico_Nome_Documento]
(
	@ID bigint,
	@cd_pes_grupo varchar(25),
	@cd_tp_carga int,
	@cd_org varchar(10),
	@cd_dst varchar(10),
	@cd_pes varchar(10),
	@Modal varchar(10),
	@cd_tp_pedido varchar(5),
	@Cd_Transportadora varchar(10),
	@Cd_Terminal varchar(10)
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
	
	set @ARRAY = (select distinct replace(Doc_Anexos,';',',') from Alerta_Email_Doc_Automatico with(nolock) where 
					ID = @ID		
					and Cd_Pes_Grupo = @cd_pes_grupo and cd_tp_carga = @cd_tp_carga 
					and Cd_Org = @cd_org and Cd_Dst =@cd_dst and Cd_pes =@Cd_Pes 
					and Modal =@Modal and cd_tp_pedido = @cd_tp_pedido
					and Cd_Transportadora = @Cd_Transportadora
					and Cd_Terminal = @Cd_Terminal)
	--Set @ARRAY = (select distinct replace(Doc_Anexos,';',',') from Alerta_Email_Doc_Automatico 
	--			where ID = 1							 
	--			and Cd_Pes_Grupo = 'P000021252' and cd_tp_carga = 0 
	--			and Cd_Org = 'ALL' and Cd_Dst ='ALL' and Cd_pes ='ALL' 
	--			and Modal = 'IA' and cd_tp_pedido = 1)
				 
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
