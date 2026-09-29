SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Container_Avaria
--SELECT * FROM vwALL_JOBs
CREATE procedure [dbo].[spATL_Container_Avaria_Sel]
(
	@Num_Proc		varchar(16),
	@Container		varchar(15),
	@Termo			varchar(1),
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
*/
if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select			
			CA.Codigo			[ID],
			CA.Dt_Termo			[Register Date],
			CA.Num_Proc			[Job],
			CA.BL				[B/L],
			HOU.HAWB			[HAWB],
			CA.Container		[Container],
			ca.Desc_Lavagem		[Wash Description],			
			CA.Valor_Termo		[Value],
			CA.Qty_Avaria		[Damaged Quantity],
			CA.Desc_Avaria		[Damaged Description],
			CA.Qty_Avaria_2		[Damaged Quantity 2],
			CA.Desc_Avaria_2	[Damaged Description 2],
			CA.Qty_Avaria_3		[Damaged Quantity 3],
			CA.Desc_Avaria_3	[Damaged Description 3],
			CA.Tp_Termo			[Type],			
			CA.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name]			
		from 
			Container_Avaria CA
			JOIN vwALL_JOBs HOU ON HOU.num_proc = CA.Num_Proc
			JOIN usuario US ON US.Cd_Usuario = CA.Cd_Usuario			
		where 
			CA.Num_Proc = @Num_Proc 
			and CA.Container = @Container
			and CA.Tp_Termo = @Termo
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select			
			CA.Codigo			[ID],
			CA.Dt_Termo			[Register Date],
			CA.Num_Proc			[Job],
			CA.BL				[B/L],
			HOU.HAWB			[HAWB],
			CA.Container		[Container],
			ca.Desc_Lavagem		[Wash Description],			
			CA.Valor_Termo		[Value],
			CA.Qty_Avaria		[Damaged Quantity],
			CA.Desc_Avaria		[Damaged Description],
			CA.Qty_Avaria_2		[Damaged Quantity 2],
			CA.Desc_Avaria_2	[Damaged Description 2],
			CA.Qty_Avaria_3		[Damaged Quantity 3],
			CA.Desc_Avaria_3	[Damaged Description 3],
			CA.Tp_Termo			[Type],			
			CA.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name]			
		from 
			Container_Avaria CA
			JOIN vwALL_JOBs HOU ON HOU.num_proc = CA.Num_Proc
			JOIN usuario US ON US.Cd_Usuario = CA.Cd_Usuario			
		where 
			CA.Num_Proc = @Num_Proc 
			and CA.Container = @Container
			and CA.Tp_Termo = @Termo
	End

GO
