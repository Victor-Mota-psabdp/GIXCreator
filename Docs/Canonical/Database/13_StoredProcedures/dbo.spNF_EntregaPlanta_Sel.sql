SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spNF_EntregaPlanta_Sel]
	@NF varchar(10),
	@Grupo varchar(3)
AS
	set @NF = right('0000000000' + @NF,10)

	select 
		Num_Proc, Dt_Conclusao 
	from 
		tarefas_processos 
	where 
		id_task=13 --and dt_conclusao IS NULL 
		and num_proc in 
		(		select Num_Proc_HIM Num_Proc from PO_HIM where ID_DC=10 and data_po_him > getdate()-30 and right(left(Num_Proc_HIM,5),3)= @Grupo and right(('000000000' + Numero_PO_HIM),10) = @NF
		Union	select Num_Proc_HIA Num_Proc from PO_HIA where ID_DC=10 and data_po_hia > getdate()-30 and right(left(Num_Proc_HIA,5),3)= @Grupo and right(('000000000' + Numero_PO_HIA),10) = @NF
		Union	select Num_Proc_HIO Num_Proc from PO_HIO where ID_DC=10 and data_po_hio > getdate()-30 and right(left(Num_Proc_HIO,5),3)= @Grupo and right(('000000000' + Numero_PO_HIO),10) = @NF
		)
	order by
		2


GO
