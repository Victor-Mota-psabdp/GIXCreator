SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from PO_HIM
--select dbo.fBusca_TipoDocCliente ('D','IMARG20080802101',2)

CREATE function [dbo].[fBusca_TipoDocCliente](
	@Tipo		char(1),	-- N = Numero, D = Data
	@Processo	varchar(16),	
	@ID			int
)
RETURNS varchar (50)

BEGIN
	Declare @Resultado varchar (50)

	If Left(@Processo,2) = 'EA' 
		Begin
			if @Tipo='N' 
				Begin
					SET @Resultado=(select top 1 Numero_PO_HEA from PO_HEA with(nolock) where num_proc_hea=@processo and ID_DC=@ID)
				End
			Else
				Begin
					SET @Resultado=convert(char,(select top 1 Data_PO_HEA from PO_HEA with(nolock)  where num_proc_hea=@processo and ID_DC=@ID),121)
				End
		End

	If Left(@Processo,2) = 'EM' 
		Begin
			if @Tipo='N' 
				Begin
					SET @Resultado=(select top 1 Numero_PO_HEM from PO_HEM with(nolock)  where num_proc_hem=@processo and ID_DC=@ID)
				End
			Else
				Begin
					SET @Resultado=convert(char,(select top 1 Data_PO_HEM from PO_HEM with(nolock)  where num_proc_hem=@processo and ID_DC=@ID),121)
				End	
		End

	If Left(@Processo,2) = 'EO' 
		Begin
			if @Tipo='N' 
				Begin
					SET @Resultado=(select top 1 Numero_PO_HEO from PO_HEO with(nolock)  where num_proc_heo=@processo and ID_DC=@ID)
				end
			Else
				Begin
					SET @Resultado=convert(char,(select top 1 Data_PO_HEO from PO_HEO with(nolock)  where num_proc_heo=@processo and ID_DC=@ID),121)
				end
		End

	If Left(@Processo,2) = 'IA' 
		Begin
			if @Tipo='N' 
				Begin
					SET @Resultado=(select top 1 Numero_PO_HIA from PO_HIA with(nolock)  where num_proc_hia=@processo and ID_DC=@ID and Numero_PO_HIA<>'')
				End
			Else
				Begin
					SET @Resultado=convert(char,(select top 1 Data_PO_HIA from PO_HIA with(nolock)  where num_proc_hia=@processo and ID_DC=@ID),121)
				End
		End

	If Left(@Processo,2) = 'IM' 
		Begin
			if @Tipo='N' 
				Begin
					SET @Resultado=(select top 1 Numero_PO_HIM  from PO_HIM with(nolock) where num_proc_him=@processo and ID_DC=@ID and Numero_PO_HIM<>'')
				End
			Else
				Begin

					SET @Resultado=convert(char,(select top 1 Data_PO_HIM from PO_HIM with(nolock) where num_proc_him=@processo and ID_DC=@ID),121)
				End
		End

	If Left(@Processo,2) = 'IO' 
		Begin
			if @Tipo='N' 
				Begin
					SET @Resultado=(select top 1 Numero_PO_HIO from PO_HIO with(nolock)  where num_proc_hio=@processo and ID_DC=@ID and Numero_PO_HIO<>'')
				end
			Else
				Begin
					if (select top 1 Data_PO_HIO from PO_HIO with(nolock)  where num_proc_hio=@processo and ID_DC=@ID) is not null 
						begin
							SET @Resultado=convert(char,(select top 1 Data_PO_HIO from PO_HIO with(nolock)  where num_proc_hio=@processo and ID_DC=@ID),121)
						end
				end
		End

	set @Resultado = replace(@Resultado,'''','')
	RETURN @Resultado

END














GO
