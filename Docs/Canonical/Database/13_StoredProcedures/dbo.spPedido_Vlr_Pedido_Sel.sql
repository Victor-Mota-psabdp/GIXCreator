SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPedido_Vlr_Pedido_Sel]--'EMCBT201802001BR'
	@Num_Proc	varchar(16)

AS
	--select distinct vlr_pedido vlr_pedido from Pedido_Ship  P with(nolock)
	--	join Pedido_Det PS with(nolock) on PS.cd_pedido = P.Cd_pedido AND PS.Cd_Produto = P.cd_produto 
	--				AND PS.Item = P.Item AND PS.Lote = P.Lote
	--	join Pedido PE with(nolock) on Pe.cd_pedido = PS.Cd_Pedido
	--where 
	--	Num_Proc = @Num_Proc
	--	and
	--	 (
	--		LEFT(Num_Proc,1) = 'I' AND PE.Cd_Grupo IN ('1')
	--	 OR
	--		PE.Cd_Grupo IN ('P000021008','P000021890','P000003779','P19318','P000016887',
	--						'P000004208','P000006403','P000029614','P000029596','P000025544','P19315','P000031844')
	--	 )

	--13/10/2023 Leandro

		select distinct vlr_pedido vlr_pedido from Pedido_Ship  P with(nolock)
		join Pedido_Det PS with(nolock) on PS.cd_pedido = P.Cd_pedido AND PS.Cd_Produto = P.cd_produto 
					AND PS.Item = P.Item AND PS.Lote = P.Lote
		join Pedido PE with(nolock) on Pe.cd_pedido = PS.Cd_Pedido
		join InsertJOB_Order_Fields IOF with(nolock) on IOF.Cd_Pes_Grupo = PE.Cd_Grupo 
		
	where 

		Num_Proc = @num_proc
		and
		(
		LEFT(Num_Proc,2) = IOF.Modal or IOF.Modal = 'AL'
		)
		and IOF.Order_Value = 1
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
