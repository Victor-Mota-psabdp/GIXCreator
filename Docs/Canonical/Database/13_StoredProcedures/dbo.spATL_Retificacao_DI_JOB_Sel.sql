SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Retificacao_DI_JOB_Sel]--'IMCSR201710495BR','C'
(
	@Num_Proc		varchar(16),
	@Tipo			char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

--if @Tipo = 'A'  and @Tipo = 'B'
--	Begin
--		select	
--			PO.Numero_DI [DI],
--			PO.Data_di [DataDI],
--			C.Nome_Raz_Soc [Importador],
--			C.Num_CPF_CNPJ [CNPJ],
--			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc,1) [PO]		
--		from vwHouse_Imp LLP with (nolock)
--			join vwPO_Imp PO with (nolock) on PO.Num_Proc = LLP.Num_Proc
--			join Pessoa C with (nolock) on C.Cd_Pes= LLP.Cd_Consig
--		Where
--			 LLP.Num_Proc = @NUM_PROC
--	End

if @Tipo = 'C'  OR  @Tipo = 'D'
	Begin
		select	
			LLP.Num_Proc			[JOB],
			PO.Numero_DI			[DI Number],
			PO.Data_di				[DI Date],
			C.Nome_Raz_Soc			[Client],
			C.Num_CPF_CNPJ			[CNPJ],
			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc,1) [PO Nº]		
		from vwHouse_Imp LLP with (nolock)
			join vwPO_Imp PO with (nolock) on PO.Num_Proc = LLP.Num_Proc
			join Pessoa C with (nolock) on C.Cd_Pes= LLP.Cd_Consig
		Where
			 LLP.Num_Proc = @Num_Proc
	End

--if @Tipo = 'N'  and @Tipo = 'O'
--	Begin
--		select	
--			PO.Numero_DI			[DI],
--			PO.Data_di				[DataDI],
--			C.Nome_Raz_Soc			[Importador],
--			C.Num_CPF_CNPJ			[CNPJ],
--			dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc,1) [PO]		
--		from vwHouse_Imp LLP with (nolock)
--			join vwPO_Imp PO with (nolock) on PO.Num_Proc = LLP.Num_Proc
--			join Pessoa C with (nolock) on C.Cd_Pes= LLP.Cd_Consig
--		Where
--			 LLP.Num_Proc = @NUM_PROC
--	End

GO
