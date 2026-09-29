SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPedido_Moeda_Sel]
	@Num_Proc	varchar(16)

AS
	--select Nome_Tp_Moeda from Pedido P with(nolock)	
	--	join Pedido_Ship PS with(nolock) on PS.cd_pedido = P.Cd_pedido
	--	join Tipo_Moeda T with(nolock) on t.Cd_Tp_Moeda = P.cd_tp_moeda
	--	join InsertJOB_Order_Fields IOF with(nolock) on IOF.Cd_Pes_Grupo = P.Cd_Grupo
	--where 
	--	Num_Proc = @Num_Proc
	--	and
	--	 (
	--		LEFT(Num_Proc,1) = 'I' and LEFT(Num_Proc,1) = 'E' AND P.Cd_Grupo IN ('1')
	--	 OR
	--		P.Cd_Grupo IN ('P000021008','P000021890','P000003779','P19318','P000016887',
	--						'P000004208','P000006403','P000029614','P000029596','P000025544','P19315','P000031844')
	--	 )

	--13/10/2023 - Leandro

		select Nome_Tp_Moeda from Pedido P with(nolock)	
		join Pedido_Ship PS with(nolock) on PS.cd_pedido = P.Cd_pedido
		join Tipo_Moeda T with(nolock) on t.Cd_Tp_Moeda = P.cd_tp_moeda
		join InsertJOB_Order_Fields IOF with(nolock) on IOF.Cd_Pes_Grupo = P.Cd_Grupo 
		
	where 

		Num_Proc = @num_proc
		and
		(
		LEFT(Num_Proc,2) = IOF.Modal or IOF.Modal = 'AL'
		)
		and IOF.Currency = 1
		and IOF.Status = 1
		
--Imp e Exp
--P000021008	GRUPO GIVAUDAN
--P000021890	GRUPO GIVAUDAN AROMA
--P000003779	GRUPO CABOT
--P19318	GRUPO LYONDELL BASEL
--P000016887	GRUPO MAUSER
--P000004208	GRUPO SUN CHEMICAL
--P000006403	GRUPO SUN PIGMENTS
--P000029614	GRUPO CBE
--P000029596	GRUPO CPE
--P000025544	GRUPO HEXION
--P19315	GRUPO CLARKE BRASIL

--Imp
--1	GRUPO DOW - Imp



GO
