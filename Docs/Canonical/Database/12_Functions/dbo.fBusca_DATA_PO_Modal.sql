SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select dbo.fbusca_DATA_po_modal('IACSR201112008BR','10')

CREATE FUNCTION [dbo].[fBusca_DATA_PO_Modal]
(
@Processo	Varchar(16),
@ID_DC		int
)
RETURNS datetime 
AS
BEGIN 
	Declare @data datetime

	IF len(@Processo) = 14
		Begin			
			set @data = (select top 1 Data_PO from PO_Master with(nolock) where num_proc_Master=@processo and ID_DC=@ID_DC)
		End
	else IF left(@Processo,2) = 'EA'
		Begin			
			set @data = (select top 1 data_PO_HEA from PO_HEA  with(nolock)  where num_proc_hea=@processo and ID_DC=@ID_DC)
		End
	else IF left(@Processo,2) = 'EM'
		Begin
			set @data = (select top 1 Data_PO_HEM from PO_HEM with(nolock)  where num_proc_hem=@processo and ID_DC=@ID_DC)
		End
	else IF left(@Processo,2) = 'EO'
		Begin
			set @data = (select top 1 Data_PO_HEO from PO_HEO with(nolock)  where num_proc_heo=@processo and ID_DC=@ID_DC)
		End
	else IF left(@Processo,2) = 'IA'
		Begin
			set @data =(select top 1 Data_PO_HIA from PO_HIA with(nolock)  where num_proc_hia=@processo and ID_DC=@ID_DC)
		End
	else IF left(@Processo,2) = 'IM'
		Begin
			set @data = (select top 1 Data_PO_HIM from PO_HIM with(nolock)  where num_proc_him=@processo and ID_DC=@ID_DC)
		End
	else IF left(@Processo,2) = 'IO'
		Begin
			set @data = (select top 1 Data_PO_HIO from PO_HIO with(nolock)  where num_proc_hio=@processo and ID_DC=@ID_DC)
		End

return @data
	
END








GO
