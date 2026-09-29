SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spDocAnexos_Rel

as


select Num_Proc,Nome_Dc,Dt_Envio from doc_anexos DA
Join Tipo_Doc_Cliente TC on TC.id_dc=DA.id_dc


GO
