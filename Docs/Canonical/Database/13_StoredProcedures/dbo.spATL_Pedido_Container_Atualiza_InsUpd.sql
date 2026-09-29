SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--18/08/2016 incluido para nao trazer qdo for "and Dt_Envio_VGM is not null"  -Cadu
CREATE procedure [dbo].[spATL_Pedido_Container_Atualiza_InsUpd]--'EMCSR201607002BR',187054,'ce'
(
	@Num_proc varchar(16),
	@cd_pedido bigint,
	@Cd_Usuario varchar(6)
)
AS

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

Declare @Temp					as varchar(5000)

Declare @JOB					as varchar(16)	
Declare	@Num_Cont				as varchar(15)
Declare	@Num_Lacre				as varchar(50)
Declare	@Peso_Bruto_VGM			as float
Declare	@UOM_VGM				as varchar(2)
Declare	@Nome_Responsavel_VGM	as varchar(100)
Declare	@Dt_Envio_VGM			as datetime
Declare	@Metodo_VGM				as varchar(1)
Declare	@Cd_Usuario1			as varchar(6)

Declare  @TAB Table
	(		
		[Num_proc]				varchar(16),		
		[Num_Cont]				varchar(15),
		[Num_Lacre]				varchar(50),
		[Peso_Bruto_VGM]		float,
		[UOM_VGM]				varchar(2),
		[Nome_Responsavel_VGM]	varchar(100),
		[Dt_Envio_VGM]			datetime,
		[Metodo_VGM]			varchar(1),
		[Cd_Usuario1]			varchar(6)
	)
	
insert into @TAB
	select @Num_proc,Num_Cont,Num_Lacre,Peso_Bruto_VGM,UOM_VGM,Nome_Responsavel_VGM,Dt_Envio_VGM,
	Metodo_VGM,@Cd_Usuario
	from pedido_container where cd_pedido = @cd_pedido
	and Dt_Envio_VGM is not null

		
Declare C_JOBs cursor for
		Select [Num_proc],[Num_Cont],[Num_Lacre],[Peso_Bruto_VGM],[UOM_VGM],[Nome_Responsavel_VGM],[Dt_Envio_VGM],
		[Metodo_VGM],[Cd_Usuario1] from @TAB	
		
Open C_JOBs 
SET NOCOUNT ON
Fetch Next From C_JOBS Into @JOB,@Num_Cont,@Num_Lacre,@Peso_Bruto_VGM,@UOM_VGM,@Nome_Responsavel_VGM,@Dt_Envio_VGM,
		@Metodo_VGM,@Cd_Usuario1

	While @@FETCH_STATUS = 0
		Begin
					
			Declare @Item_cont as bigint
			set @Item_cont = (select CH.Item_Cont_EM from Container_Hou_Exp_mar CH with(nolock)
				join Container_Mas_Exp_Mar CM with(nolock) on CH.Num_Proc_MEM = CM.Num_Proc_MEM 
							and CH.Item_Cont_EM = CM.Item_Cont_EM
				and replace(replace(Num_Cont_EM,'-',''),' ','') = @Num_Cont
				and Num_Proc_HEM = @JOB)
			
			begin
				--exec [spContainerEM_New_InsUpd] @Item_cont,@JOB,@Num_Cont,'20ft - Box',@Num_Lacre,
				--	NULL,NULL,@Peso_Bruto_VGM,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
				exec spContainerEM_Pedido_Container_Atualiza_InsUpd @Item_cont,@JOB,@Num_Cont,'40ft - High Cube',
					@Num_Lacre,@Peso_Bruto_VGM
			end	
			
			if @Dt_Envio_VGM is not null
				begin				
					exec [spContainerAdditionalInfo_InsUpd]@JOB,@Num_Cont,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
						@Peso_Bruto_VGM,@UOM_VGM,@Dt_Envio_VGM,@Nome_Responsavel_VGM,@Metodo_VGM,NULL,NULL
				end
			
			
											
Fetch Next From C_JOBS Into @JOB,@Num_Cont,@Num_Lacre,@Peso_Bruto_VGM,@UOM_VGM,	@Nome_Responsavel_VGM,@Dt_Envio_VGM,
		@Metodo_VGM,@Cd_Usuario1

		End
	
close C_JOBS
deallocate C_JOBS






GO
