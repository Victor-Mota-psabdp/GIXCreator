SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spPO_Sel]
		@num_proc	Varchar(16),
		@ID_DC		int

AS


--Busca numero de documentos em todos os modais
--utilizado para Intergração BO, DOW
--23-06 - Anderson

if left(@num_proc,2)='IM'
	Begin
		Select 
				Numero_PO_HIM Num_Doc,Data_PO_HIM Data_DC
		From
				Po_Him With(nolock)
		Where
				Num_proc_him=@num_proc and 
				ID_DC=@ID_DC
	End
if left(@num_proc,2)='IO'
	Begin
		Select 
				Numero_PO_HIO Num_Doc,Data_PO_HIO Data_DC
		From
				Po_HiO With(nolock)
		Where
				Num_proc_hiO=@num_proc and 
				ID_DC=@ID_DC
	End
if left(@num_proc,2)='IA'
	Begin
		Select 
				Numero_PO_HIA Num_Doc,Data_PO_HIA Data_DC
		From
				Po_HiA With(nolock)
		Where
				Num_proc_hiA=@num_proc and 
				ID_DC=@ID_DC
	End
if left(@num_proc,2)='EA'
	Begin
		Select 
				Numero_PO_HEA Num_Doc,Data_PO_HEA Data_DC
		From
				Po_HEA With(nolock)
		Where
				Num_proc_hEA=@num_proc and 
				ID_DC=@ID_DC
	End
if left(@num_proc,2)='EM'
	Begin
		Select 
				Numero_PO_HEM Num_Doc,Data_PO_HEM Data_DC
		From
				Po_HEM With(nolock)
		Where
				Num_proc_hEM=@num_proc and 
				ID_DC=@ID_DC
	End
if left(@num_proc,2)='EO'
	Begin
		Select 
				Numero_PO_HEO Num_Doc,Data_PO_HEO Data_DC
		From
				Po_HEO With(nolock)
		Where
				Num_proc_hEO=@num_proc and 
				ID_DC=@ID_DC
	End



GO
