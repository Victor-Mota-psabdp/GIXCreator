SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_TranfRefer_Sel]--'IMLVS201502001BR'
(
@Num_ProcTemp Varchar(16)
)
as

select Num_Proc_HIM Num_Proc,ID_DC,Numero_PO_HIM Numero_PO,ID_DC,Data_PO_HIM Data_PO from PO_HIM
where Num_Proc_HIM = @Num_ProcTemp

UNION ALL

select Num_Proc_HIA Num_Proc, ID_DC,Numero_PO_HIA Numero_PO,ID_DC,Data_PO_HIA Data_PO from PO_HIA
where Num_Proc_HIA = @Num_ProcTemp

UNION ALL

select Num_Proc_HIO Num_Proc, ID_DC,Numero_PO_HIO Numero_PO,ID_DC,Data_PO_HIO Data_PO from PO_HIO
where Num_Proc_HIO = @Num_ProcTemp
GO
