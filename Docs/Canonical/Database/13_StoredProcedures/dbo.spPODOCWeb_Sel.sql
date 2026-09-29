SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[spPODOCWeb_Sel] --'13/0849507-4',5
		@ID_DC		int,
		@Grupo		varchar(3)

AS

declare @dtInicial datetime
declare @dtFinal datetime
			set @dtInicial = cast(year(getdate()) as varchar(4)) + '-' + cast(month(getdate()) as varchar(2)) + '-' + '01'

			set @dtFinal = getdate()

--Busca numero de documentos em todos os modais
--utilizado para Intergração BO, DOW
--23-06 - Anderson

		Select 
				Numero_PO_HIM Num_Doc,Data_PO_HIM Data_DC,num_proc_him
		From
				Po_Him PO
		Where
			dt_ins between @dtInicial and @dtFinal and
			right(left(Num_proc_him,5),3) = @Grupo and 
			ID_DC=@ID_DC

union

		Select 
				Numero_PO_HIO Num_Doc,Data_PO_HIO Data_DC,num_proc_hio
		From
				Po_HiO
		Where
			dt_ins between @dtInicial and @dtFinal and
			right(left(Num_proc_hio,5),3) = @Grupo and 
			ID_DC=@ID_DC

union
			Select 
				Numero_PO_HIA Num_Doc,Data_PO_HIA Data_DC,num_proc_hia
		From
				Po_HiA
		Where
			dt_ins between @dtInicial and @dtFinal and
			right(left(Num_proc_hia,5),3) = @Grupo and 
			ID_DC=@ID_DC
	
union
		Select 
				Numero_PO_HEA Num_Doc,Data_PO_HEA Data_DC,num_proc_hea
		From
				Po_HEA
		Where
			dt_ins between @dtInicial and @dtFinal and
			right(left(Num_proc_hea,5),3) = @Grupo and 
			ID_DC=@ID_DC
	
union
		Select 
				Numero_PO_HEM Num_Doc,Data_PO_HEM Data_DC,num_proc_hem
		From
				Po_HEM
		Where
			dt_ins between @dtInicial and @dtFinal and
			right(left(Num_proc_hem,5),3) = @Grupo and 
			ID_DC=@ID_DC
union
		Select 
				Numero_PO_HEO Num_Doc,Data_PO_HEO Data_DC,num_proc_heo
		From
				Po_HEO
		Where
			dt_ins between @dtInicial and @dtFinal and
			right(left(Num_proc_heo,5),3) = @Grupo and 
			ID_DC=@ID_DC

Union 


		Select 
				Null Num_Doc,Null  Data_DC,'IMFMC' num_proc_him

order by 1 desc
GO
