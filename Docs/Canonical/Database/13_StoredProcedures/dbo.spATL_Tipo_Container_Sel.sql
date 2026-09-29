SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Container
CREATE procedure [dbo].[spATL_Tipo_Container_Sel]
(
	@Cd_Tp_Cont char(3),
	@Nome_Tp_Cont varchar(50),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select Cd_Tp_Cont AS Code,Nome_Tp_Cont AS [Container Name],Cd_CC_Ofc [SCAC],
		CD_Smart [Code Smart],Capacidade_M3 [M3],Carrier_Code [Carrier Code]
		from Tipo_Container with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Tp_Cont AS Code,Nome_Tp_Cont AS [Container Name],Cd_CC_Ofc [SCAC],
		CD_Smart [Code Smart],Capacidade_M3 [M3],Carrier_Code [Carrier Code]
		from Tipo_Container with(nolock)
		where Cd_Tp_Cont = @Cd_Tp_Cont
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Tp_Cont AS Code,Nome_Tp_Cont AS [Container Name],Cd_CC_Ofc [SCAC],
		CD_Smart [Code Smart],Capacidade_M3 [M3],Carrier_Code [Carrier Code]
		from Tipo_Container with(nolock)
		where Nome_Tp_Cont = @Nome_Tp_Cont
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select Cd_Tp_Cont AS Code,Nome_Tp_Cont AS [Container Name],Cd_CC_Ofc [SCAC],
		CD_Smart [Code Smart],Capacidade_M3 [M3],Carrier_Code [Carrier Code]
		from Tipo_Container with(nolock)
		where Nome_Tp_Cont = @Nome_Tp_Cont AND Cd_Tp_Cont <> @Cd_Tp_Cont
	End
	

	

GO
