SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRetificacaoDI_JOB_Sel]--'IMCSR201411147BR'
	@NUM_PROC varchar(16)
AS
select	
	PO.Numero_PO_HIM [DI],
	PO.Data_PO_HIM [DataDI],
	C.Nome_Raz_Soc [Importador],
	C.Num_CPF_CNPJ [CNPJ],
	dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_Lim,1) [PO]
		
from LLP_IMP_Mar LLP with (nolock)
	join House_Imp_Mar HOU with (nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_Lim
	join Po_HIM PO with (nolock) on PO.Num_Proc_HIM = LLP.Num_Proc_Lim and ID_DC = 5
	join Pessoa C with (nolock) on C.Cd_Pes= HOu.Cd_Consig_HIM
Where
	 LLP.Num_Proc_Lim = @NUM_PROC
	 
	 











GO
