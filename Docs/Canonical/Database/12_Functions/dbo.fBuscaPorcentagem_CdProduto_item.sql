SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
select dbo.fBuscaPorcentagem_CdProduto('IMSLA201703033BR','124548')

select [dbo].[fBuscaPorcentagem_CdProduto]('IMSLA201703033BR','216820','124548')

*/


Create function [dbo].[fBuscaPorcentagem_CdProduto_item] --('IACAR20091200801','40568')
(
	@Num_Proc Char(16),
	@cd_produto		int,
	@Item int
)
returns	Float
as
BEGIN
	Declare @qtyPedido as Float
	Declare @qtyTotal as Float
		
	IF len(@Num_Proc) = 16
		Begin
			Set @qtypedido = (
					select sum(ps.qty) from pedido_ship ps with(nolock)
					where cd_produto=@cd_produto and num_proc=@num_proc and ps.Item = @Item)

			set @qtytotal = (
					select sum(ps.qty) from pedido_ship ps with(nolock)
					where num_proc=@num_proc)
		End
	ELSE
		Begin
			Set @qtypedido = (
					select sum(ps.qty) from pedido_ship ps with(nolock)
					where cd_produto=@cd_produto and ps.Item = @Item and num_proc  in
					(
						select distinct Num_Proc_HEA from house_exp_aer with(nolock) where Num_Proc_MEA = @num_proc
						UNION
						select distinct Num_Proc_HEM from house_exp_mar with(nolock) where Num_Proc_MEM = @num_proc
						UNION
						select distinct Num_Proc_HIA from house_imp_aer with(nolock) where Num_Proc_MIA = @num_proc
						UNION
						select distinct Num_Proc_HIM from house_imp_mar with(nolock) where Num_Proc_MIM = @num_proc
					))
			set @qtytotal = (
					select sum(ps.qty) from pedido_ship ps
					where num_proc in 
					(
						select distinct Num_Proc_HEA from house_exp_aer with(nolock) where Num_Proc_MEA = @num_proc
						UNION
						select distinct Num_Proc_HEM from house_exp_mar with(nolock) where Num_Proc_MEM = @num_proc
						UNION
						select distinct Num_Proc_HIA from house_imp_aer with(nolock) where Num_Proc_MIA = @num_proc
						UNION
						select distinct Num_Proc_HIM from house_imp_mar with(nolock) where Num_Proc_MIM = @num_proc
					))
		End

		Return (@qtypedido/@qtytotal)
END
GO
