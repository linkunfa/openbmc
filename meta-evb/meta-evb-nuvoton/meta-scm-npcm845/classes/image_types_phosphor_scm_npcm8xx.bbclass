MERGED_SUFFIX = "merged"
UBOOT_SUFFIX:append = ".${MERGED_SUFFIX}"
UBOOT_BINARY := "u-boot.${UBOOT_SUFFIX}"
BOOTBLOCK := "BootBlockAndHeader.bin"
ATF_BINARY := "bl31AndHeader.bin"
OPTEE_BINARY := "teeAndHeader.bin"
UBOOT_AND_HEADER_BINARY := "UbootAndHeader.bin"
KMT_TIPFW_BINARY := "Kmt_TipFwL0_Skmt_TipFwL1.bin"
KMT_TIPFW_BB_BINARY := "Kmt_TipFw_BootBlock.bin"
KMT_TIPFW_BB_BL31_BINARY := "Kmt_TipFw_BootBlock_BL31.bin"
KMT_TIPFW_BB_BL31_TEE_BINARY := "Kmt_TipFw_BootBlock_BL31_Tee.bin"
KMT_TIPFW_BB_UBOOT_BINARY := "u-boot.bin.merged"


IGPS_DIR = "${STAGING_DIR_NATIVE}/${datadir}/npcm8xx-igps"
inherit logging

# Prepare the Bootblock and U-Boot images using npcm8xx-bingo
do_prepare_bootloaders() {
    local olddir="$(pwd)"
    cd ${DEPLOY_DIR_IMAGE}

    if [ "${SECURED_OS}" = "True" ]; then
        bingo ${IGPS_DIR}/BL31_AndHeader.xml \
                -o ${ATF_BINARY}

        bingo ${IGPS_DIR}/OpTeeAndHeader.xml \
                -o ${OPTEE_BINARY}
    fi

    bingo ${IGPS_DIR}/UbootHeader_${DEVICE_GEN}.xml \
            -o ${UBOOT_AND_HEADER_BINARY}

    cd "$olddir"
}

python do_merge_bootloaders() {

    def BigNum_2_Array(num, size, print_it):
        arr = bytearray(size)
        for ind in range(size):
            arr[ind] = (num >> (ind*8)) & 255
        if (print_it):
            res = "-".join(format(x, '-02X') for x in arr)
        return arr

    # Replace_binary_array: used to embed an array inside an image. Used for timestamp and address pointers.
    # bArray=True: num is an array, just write it in the file
    # bArray=False: num is a number in little endian, convert to array
    def Replace_binary_array(input_file, offset, num, size, bArray, title):
        currpath = os.getcwd()

        # read input file:
        if (os.path.isfile(input_file) == False):
            raise Exception('Missing file')

        bin_file = open(input_file, "rb")
        input = bin_file.read()
        bin_file.close()

        if (bArray == True):
            arr = BigNum_2_Array(num, size, True)
        else:
            arr = bytearray(num)

        #print(("size of input " + str(len(input))))
        output = input[:offset] + arr + input[(offset + size):]


        input_file = open(input_file, "w+b")
        input_file.write(output)
        input_file.close()

        os.chdir(currpath)

    def allign_to_sector(num, round_to):
        if (num % round_to == 0):
            return num
        else:
            return  num + round_to - (num % round_to)
        

    def Uboot_header_embed_pointers_to_all_fw():
        bbS_size =       os.path.getsize(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('BOOTBLOCK',True)))
        bl31S_size  =    os.path.getsize(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('ATF_BINARY',True)))
        OpTeeS_size =    os.path.getsize(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('OPTEE_BINARY',True)))
        ubootS_size =    os.path.getsize(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('UBOOT_AND_HEADER_BINARY',True)))

        bbS =  512*1024
        bl31S  = bbS +    allign_to_sector(bbS_size    , 0x1000)
        OpTeeS = bl31S +  allign_to_sector(bl31S_size  , 0x1000)
        ubootS = OpTeeS + allign_to_sector(OpTeeS_size , 0x1000)
        Replace_binary_array(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('UBOOT_AND_HEADER_BINARY',True)), 0x1D8, ubootS        , 4, True, "uboot base address")
        Replace_binary_array(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('UBOOT_AND_HEADER_BINARY',True)), 0x1DC, ubootS_size   , 4, True, "uboot base size")

    def Merge_bin_files_and_pad(inF1, inF2, outF, align, padding_at_end):
        padding_size = 0
        padding_size_end = 0
        F1_size = os.path.getsize(inF1)
        F2_size = os.path.getsize(inF2)

        if ((F1_size % align) != 0):
            padding_size = align - (F1_size % align)

        if ((F2_size % align) != 0):
            padding_size_end = align - (F2_size % align)

        with open(outF, "wb") as file3:
            with open(inF1, "rb") as file1:
                data = file1.read()
                file3.write(data)

            file3.write(b'\xFF' * padding_size)

            with open(inF2, "rb") as file2:
                data = file2.read()
                file3.write(data)

            file3.write(b'\xFF' * padding_size_end)

        file1.close()
        file2.close()
        file3.close()

    Uboot_header_embed_pointers_to_all_fw()

    Merge_bin_files_and_pad(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BINARY',True)),
        os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('BOOTBLOCK',True)),
        os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_BINARY',True)),
        0x1000, 0x20)

    if d.getVar('SECURED_OS', True) == "True":
        Merge_bin_files_and_pad(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('ATF_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_BL31_BINARY',True)),
            0x1000, 0x20)

        Merge_bin_files_and_pad(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_BL31_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('OPTEE_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_BL31_TEE_BINARY',True)),
            0x1000, 0x20)

        Merge_bin_files_and_pad(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_BL31_TEE_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('UBOOT_AND_HEADER_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_UBOOT_BINARY',True)),
            0x1000, 0x20)
    else:
        Merge_bin_files_and_pad(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('UBOOT_AND_HEADER_BINARY',True)),
            os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True), '%s' % d.getVar('KMT_TIPFW_BB_UBOOT_BINARY',True)),
            0x1000, 0x20)
}

prepare_secureos = "${@ "arm-trusted-firmware:do_deploy optee-os:do_deploy" if bb.utils.to_boolean(d.getVar('SECURED_OS')) else "" }"

do_prepare_bootloaders[depends] += " \
    npcm8xx-tip-fw:do_deploy \
    npcm8xx-bootblock:do_deploy \
    ${prepare_secureos} \
    npcm7xx-bingo-native:do_populate_sysroot \
    npcm8xx-igps-native:do_populate_sysroot \
    "

# link images for we only need to flash partial image with idea name
do_generate_ext4_tar:append() {
    cd ${DEPLOY_DIR_IMAGE}
    ln -sf ${KMT_TIPFW_BB_UBOOT_BINARY} image-u-boot
    ln -sf ${DEPLOY_DIR_IMAGE}/${FLASH_KERNEL_IMAGE} image-kernel
    ln -sf ${S}/ext4/${IMAGE_LINK_NAME}.${FLASH_EXT4_BASETYPE}.zst image-rofs
    ln -sf ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.rwfs.${FLASH_EXT4_OVERLAY_BASETYPE} image-rwfs
    ln -sf ${IMAGE_NAME}.rootfs.wic.gz image-emmc.gz
}

addtask do_prepare_bootloaders before do_generate_static after do_generate_rwfs_static
addtask do_merge_bootloaders before do_generate_static after do_prepare_bootloaders
addtask do_merge_bootloaders before do_generate_ext4_tar after do_prepare_bootloaders

# Include the full bootblock and u-boot in the final static image
python do_generate_static:append() {
    _append_image(os.path.join(d.getVar('DEPLOY_DIR_IMAGE', True),
                               'u-boot.%s' % d.getVar('UBOOT_SUFFIX',True)),
                  int(d.getVar('FLASH_UBOOT_OFFSET', True)),
                  int(d.getVar('FLASH_KERNEL_OFFSET', True)))
}

do_make_ubi:append() {
    # Concatenate the uboot and ubi partitions
    dd bs=1k conv=notrunc seek=${FLASH_UBOOT_OFFSET} \
        if=${DEPLOY_DIR_IMAGE}/u-boot.${UBOOT_SUFFIX} \
        of=${IMGDEPLOYDIR}/${IMAGE_NAME}.ubi.mtd
}

do_make_ubi[depends] += "${PN}:do_prepare_bootloaders"
do_generate_ubi_tar[depends] += "${PN}:do_prepare_bootloaders"
do_generate_ubi_tar[depends] += "${PN}:do_merge_bootloaders"
do_generate_static_tar[depends] += "${PN}:do_prepare_bootloaders"
do_generate_static_tar[depends] += "${PN}:do_merge_bootloaders"
do_generate_ext4_tar[depends] += "${PN}:do_prepare_bootloaders"
do_generate_ext4_tar[depends] += "${PN}:do_merge_bootloaders"
